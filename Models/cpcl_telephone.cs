using System.ComponentModel.DataAnnotations;

namespace cpclapp.Models
{
    public class cpcl_telephone
    {
        [Key]

        public int employeeId { get; set; }

        [Required]
        public int prno { get; set; }

        [Required]

        public String name { get; set; } = "";

        [Required]
        public String Designation { get; set; } = "";

        [Required]
        public String DEPARTMENT { get; set; } = "";

      
        public int Intercom_no { get; set; } 

        [Required]
        public int PT_Extn { get; set; } 

     
        public Int64 PT_Direct { get; set; } 

        [Required]
        public String Residence { get; set; } = "";

        [Required]
        public Int64 Mobile_no { get; set; } 

        [Required]
        public String email_id { get; set; } = "";

       
        public DateTime Modified_date { get; set; } 

       
        public int GRADE { get; set; }

        public Empview Empview { get; set; }

    }
}
