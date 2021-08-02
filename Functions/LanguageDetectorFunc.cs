using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.EventHubs;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using System.Data.SqlClient;
using Newtonsoft.Json;
using CloudPlatrforms.Project.Models;

namespace CloudPlatrforms.Project.Functions
{
    public static class LanguageDetectorFunc
    {
        [FunctionName("LanguageDetectorFunc")]
        public static async Task Run(
            [EventHubTrigger("redditmessagestopic", 
                ConsumerGroup = "language-detector-consumer", 
                Connection = "EventHubConnectionString")] 
            EventData[] events, 
            ILogger log)
        {
            log.LogInformation($"Starting executing function");
            
            try
            {
                var connectionString = Environment.GetEnvironmentVariable("StatisticsDBConnectionString");

                using var connection = new SqlConnection(connectionString);
                connection.Open();

                var exceptions = new List<Exception>();
                log.LogInformation($"Got {events.Count()} new messages");
                foreach (EventData eventData in events)
                {
                    try
                    {
                        string messageBody = Encoding.UTF8.GetString(eventData.Body.Array, eventData.Body.Offset, eventData.Body.Count);

                        await ProcessRedditMessage(messageBody, connection, log);
                    }
                    catch (Exception e)
                    {
                        // We need to keep processing the rest of the batch - capture this exception and continue.
                        // Also, consider capturing details of the message that failed processing so it can be processed again later.
                        exceptions.Add(e);
                    }
                }

                // Once processing of the batch is complete, if any messages in the batch failed processing throw an exception so that there is a record of the failure.

                if (exceptions.Count > 1)
                    throw new AggregateException(exceptions);

                if (exceptions.Count == 1)
                    throw exceptions.Single();

                log.LogInformation($"Processing completed successfully");
            }
            catch (Exception e)
            {
                log.LogError(e, "Error executing LanguageDetectorFunc function");
            }
        }

        
        private static async Task ProcessRedditMessage(string serializedMessage, SqlConnection connection, ILogger log)
        {
            var comment = JsonConvert.DeserializeObject<RedditComment>(serializedMessage);

            var commentLanguage = DetectLanguage(comment.body);


        }

        private static async Task<string> DetectLanguage(string text) 
        {
            var rndm = new Random();
            var randomNumber = rndm.NextDouble();

            if (randomNumber > 0.6) {
                return "en";
            }

            if (randomNumber > 0.3) {
                return "es";
            }

            if (randomNumber > 0.1) {
                return "fr";
            }

            return "uk";
        }

        private static async Task WriteToDB(object obj, SqlConnection connection, ILogger log) 
        {
            var text = "UPDATE SalesLT.SalesOrderHeader " +
                "SET [Status] = 5  WHERE ShipDate < GetDate();";

            using var cmd = new SqlCommand(text, connection);
            // Execute the command and log the # rows affected.
            var rows = await cmd.ExecuteNonQueryAsync();
            log.LogInformation($"{rows} rows were updated");
        }
    }
}
