using System.ComponentModel.DataAnnotations;

namespace cpclapp.Models
{
    public class cpcl_lop_day_wise
    {

        [Key]

        public int employeeId { get; set; }

        [Required]
        public String company_no { get; set; } = "";

        [Required]
        public String location_no { get; set; } = "";

        [Required]
        public int pr_no { get; set; } 

        [Required]
        public int period { get; set; }

        [Required]
        public DateTime from_dt { get; set; }

        [Required]
        public DateTime to_dt { get; set; }

        [Required]
        public float days { get; set; }

        [Required]
        public String flag { get; set; } = "";

        [Required]
        public String time_stamp { get; set; } = "";
    }
}
