using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CloudPlatrforms.Project.WebApi.Data;
using CloudPlatrforms.Project.WebApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace CloudPlatrforms.Project.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class StatisticsController : ControllerBase
    {
        private readonly RedditCommentsProjectContext _dbContext;
        private readonly ILogger<StatisticsController> _logger;

        public StatisticsController(
            ILogger<StatisticsController> logger,
            RedditCommentsProjectContext dbContext)
        {
            _dbContext = dbContext;
            _logger = logger;
        }

        [HttpGet]
        public async Task<Statistics> Get()
        {
            _logger.LogInformation("Received Statistics GET request");

            var languageStatistics = await _dbContext.DetectedLanguages
                .GroupBy(x => x.Language)
                .Select(x => new LanguageStatistics
                {
                    Language = x.Key,
                    NumOfMessages = x.Count()
                })
                .OrderByDescending(x => x.NumOfMessages)
                .ToListAsync();

            var sentimentStatistics = await _dbContext.MessageSentiments
                .GroupBy(x => x.Sentiment)
                .Select(x => new SentimentStatistics
                {
                    Sentiment = x.Key,
                    NumOfMessages = x.Count()
                })
                .OrderByDescending(x => x.NumOfMessages)
                .ToListAsync();

            var keywordsStatistics = await _dbContext.MessageKeywords
                .GroupBy(x => x.Keyword)
                .Select(x => new KeywordStatistics
                {
                    Keyword = x.Key,
                    NumOfMessages = x.Count()
                })
                .OrderByDescending(x => x.NumOfMessages)
                .Take(10)
                .ToListAsync();

            return new Statistics
            {
                LanguagesStatistics = languageStatistics,
                SentimentsStatistics = sentimentStatistics,
                KeywordsStatistics = keywordsStatistics
            };
        }
    }
}
