using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CloudPlatrforms.Project.WebApi.Models
{
    public class MessageKeyword
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        [MaxLength(20)]
        public string CommentID { get; set; }
        [MaxLength(250)]
        public string Keyword { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
