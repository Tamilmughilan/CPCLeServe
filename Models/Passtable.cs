using System;
using System.ComponentModel.DataAnnotations;

namespace cpclapp.Models
{
    public class Passtable
    {
        [Key]
        public int employeeId { get; set; }

        [Required]
        public int prno { get; set; }

        [Required]
        public String password { get; set; } = "";

        [Required]
        public DateTime date { get; set; } 

        
    }
}
