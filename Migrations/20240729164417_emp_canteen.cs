using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace cpclapp.Migrations
{
    /// <inheritdoc />
    public partial class emp_canteen : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_cpcl_lop_day_wise_pr_no",
                table: "cpcl_lop_day_wise",
                column: "pr_no");

            migrationBuilder.AddForeignKey(
                name: "FK_cpcl_lop_day_wise_Empview_pr_no",
                table: "cpcl_lop_day_wise",
                column: "pr_no",
                principalTable: "Empview",
                principalColumn: "H01_EMP_NUM",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_cpcl_lop_day_wise_Empview_pr_no",
                table: "cpcl_lop_day_wise");

            migrationBuilder.DropIndex(
                name: "IX_cpcl_lop_day_wise_pr_no",
                table: "cpcl_lop_day_wise");
        }
    }
}
