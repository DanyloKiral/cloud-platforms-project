using System;
using CloudPlatrforms.Project.WebApi.Models;
using Microsoft.EntityFrameworkCore;

namespace CloudPlatrforms.Project.WebApi.Data
{
    public class RedditCommentsProjectContext : DbContext
    {
        public RedditCommentsProjectContext(DbContextOptions<RedditCommentsProjectContext> options)
            : base(options)
        {
        }

        public DbSet<DetectedLanguage> DetectedLanguages { get; set; }
        public DbSet<MessageKeyword> MessageKeywords { get; set; }
        public DbSet<MessageSentiment> MessageSentiments { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<DetectedLanguage>().ToTable("DetectedLanguages");
            modelBuilder.Entity<MessageKeyword>().ToTable("MessageKeywords");
            modelBuilder.Entity<MessageSentiment>().ToTable("MessageSentiments");
        }
    }
}
