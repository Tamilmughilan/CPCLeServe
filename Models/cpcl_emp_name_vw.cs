using System.ComponentModel.DataAnnotations;

namespace cpclapp.Models
{
    public class cpcl_emp_name_vw
    {
        [Key]

        public int employeeId { get; set; }

        [Required]

        public int h01_emp_num { get; set; }

        [Required]

        public String h01_first_name { get; set; } = "";

        [Required]

        public String c02_function_code { get; set; } = "";

        [Required]
        public String c03_organisation_code { get; set; } = "";

        [Required]
        public String C02_Function_Desc { get; set; } = "";


        [Required]

        public DateOnly H01_join_date { get; set; }

        [Required]

        public int c09_grade { get; set; }

        [Required]

        public int C02_Cost_Center_No { get; set; }


    }
}
