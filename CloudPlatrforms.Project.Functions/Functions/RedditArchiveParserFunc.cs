using System;
using System.IO;
using CloudPlatrforms.Project.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace CloudPlatrforms.Project.Functions
{
    public static class RedditArchiveParserFunc
    {
        [FunctionName("RedditArchiveParserFunc")]
        public static void Run(
            [BlobTrigger("reddit-comments-archive/{name}", Connection = "ProjectdatastoreConnectionString")]Stream myBlob, 
            string name, 
            [EventHub("redditMessagesTopic", Connection = "EventHubConnectionString")]IAsyncCollector<string> outputEvents,
            ILogger log)
        {
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");

            using var reader = new StreamReader(myBlob);
            
            while (!reader.EndOfStream)
            {
                var line = reader.ReadLine();

                var model = JsonConvert.DeserializeObject<RedditComment>(line);
                var serialized = JsonConvert.SerializeObject(model);

                log.LogInformation($"Pushinh object to event hub = {serialized}");

                outputEvents.AddAsync(serialized);
            }

            log.LogInformation($"Finished parsing file");
        }
    }
}
