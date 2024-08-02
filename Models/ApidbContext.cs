using Microsoft.EntityFrameworkCore;

namespace cpclapp.Models
{
    public class ApidbContext : DbContext
    {
        public ApidbContext(DbContextOptions<ApidbContext> options) : base(options)
        {
        }

        public DbSet<Empview> Empview { get; set; }
        public DbSet<Passtable> Passtables { get; set; }
        public DbSet<cpcl_telephone> cpcl_Telephones { get; set; }
        public DbSet<cpcl_lop_day_wise> cpcl_lop_day_wise { get; set; }
        public DbSet<cpcl_emp_name_vw> cpcl_emp_name_vw { get; set; }
        public DbSet<cpcl_cant_daily_menu_items> cpcl_cant_daily_menu_items { get; set; }

        public DbSet<Notification> Notifications { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Configure the relationship between Passtable and Employees
            modelBuilder.Entity<Passtable>()
                .HasOne<Empview>()
                .WithMany()
                .HasForeignKey(p => p.prno)
                .HasPrincipalKey(e => e.H01_EMP_NUM);

            // Ensure prNo is unique in Passtable
            modelBuilder.Entity<Passtable>()
                .HasIndex(p => p.prno)
                .IsUnique();

            // Configure the relationship between Empview and cpcl_telephone
            modelBuilder.Entity<Empview>()
                .HasOne(e => e.Telephone)
                .WithOne(t => t.Empview)
                .HasForeignKey<cpcl_telephone>(t => t.prno)
                .HasPrincipalKey<Empview>(e => e.H01_EMP_NUM);

            modelBuilder.Entity<cpcl_lop_day_wise>()
                .HasOne<Empview>()
                .WithMany()
                .HasForeignKey(l => l.pr_no)
                .HasPrincipalKey(e => e.H01_EMP_NUM);

            base.OnModelCreating(modelBuilder);
        }
    }
}
