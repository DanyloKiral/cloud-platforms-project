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
    public static class SentimentAnalyzerFunc
    {
        [FunctionName("SentimentAnalyzerFunc")]
        public static async Task Run(
            [EventHubTrigger("redditmessagestopic", 
                ConsumerGroup = "sentiment-analyzer-consumer", 
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
                        log.LogError(e, "Event data proccess failed");
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
                log.LogError(e, "Error executing function");
            }
        }

        
        private static async Task ProcessRedditMessage(string serializedMessage, SqlConnection connection, ILogger log)
        {
            var comment = JsonConvert.DeserializeObject<RedditComment>(serializedMessage);

            var sentiment = await AnalyzeSentiment(comment.body);

            await WriteToDB(comment.id, sentiment, connection, log);
        }

        private static Task<string> AnalyzeSentiment(string text) 
        {
            var rndm = new Random();
            var randomNumber = rndm.NextDouble();

            if (randomNumber > 0.8) {
                return Task.FromResult("POSITIVE");
            }

            if (randomNumber > 0.3) {
                return Task.FromResult("NEUTRAL");
            }

            return Task.FromResult("NEGATIVE");
        }

        private static async Task WriteToDB(string commentId, string sentiment, SqlConnection connection, ILogger log) 
        {
            var text = $@"
                INSERT INTO MessageSentiments (CommentID, Sentiment, CreatedAt)
                VALUES ('{commentId}', '{sentiment}', GETUTCDATE())";

            using var cmd = new SqlCommand(text, connection);
            // Execute the command and log the # rows affected.
            var rows = await cmd.ExecuteNonQueryAsync();
        }
    }
}
