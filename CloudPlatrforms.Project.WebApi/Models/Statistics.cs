using System;
using System.Collections.Generic;

namespace CloudPlatrforms.Project.WebApi.Models
{
    public class LanguageStatistics
    {
        public string Language { get; set; }
        public long NumOfMessages { get; set; }
    }

    public class SentimentStatistics
    {
        public string Sentiment { get; set; }
        public long NumOfMessages { get; set; }
    }

    public class KeywordStatistics
    {
        public string Keyword { get; set; }
        public long NumOfMessages { get; set; }
    }

    public class Statistics
    {
        public IEnumerable<LanguageStatistics> LanguagesStatistics { get; set; }
        public IEnumerable<SentimentStatistics> SentimentsStatistics { get; set; }
        public IEnumerable<KeywordStatistics> KeywordsStatistics { get; set; }
    }
}
