using System;
using System.ComponentModel.DataAnnotations;

namespace cpclapp.Models
{
    public class Empview
    {
        [Key]
        public int employeeId { get; set; }

        [Required]
        public int H01_EMP_NUM { get; set; }

        [Required]
        public String H01_First_Name { get; set; } = "";

        [Required]
        public String C12_Positioncode { get; set; } = "";

        [Required]
        public String P08_Payset_code { get; set; } = "";

        [Required]

        public DateTime H01_birth_date { get; set; } 

        [Required]

        public DateTime H01_join_date { get; set; } 

        [Required]
        public String C02_Function_Code { get; set; } = "";

        [Required]
        public String C02_Function_Desc { get; set; } = "";

        public cpcl_telephone Telephone { get; set; }

    }
}
