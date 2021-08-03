using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CloudPlatrforms.Project.WebApi.Models
{
    public class MessageSentiment
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        [MaxLength(20)]
        public string CommentID { get; set; }
        [MaxLength(10)]
        public string Sentiment { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
