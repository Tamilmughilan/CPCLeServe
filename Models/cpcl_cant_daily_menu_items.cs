using System.ComponentModel.DataAnnotations;

namespace cpclapp.Models
{
    public class cpcl_cant_daily_menu_items
    {
        [Key]
        public int employeeId { get; set; }

        [Required]
        public DateTime CDATE { get; set; }

        [Required]

        public int ITEM_CODE { get; set; }

        [Required]

        public String SUB_ITEM_CODE { get; set; } = "";

        [Required]

        public int CQTY { get; set; }

        [Required]

        public int sysid { get; set; }

        [Required]

        public float act_rate { get; set; }

        [Required]

        public String subitemdesc { get; set; } = "";

        [Required]

        public String itemdesc { get; set; } = "";

    }
}
