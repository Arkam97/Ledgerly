using Ledgerly.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;

namespace Ledgerly.Persistence;

public class LedgerlyDbContext : DbContext
{
    public LedgerlyDbContext(DbContextOptions<LedgerlyDbContext> options) : base(options)
    {
    }

    public DbSet<Organization> Organizations { get; set; }
    public DbSet<User> Users { get; set; }
    public DbSet<Customer> Customers { get; set; }
    public DbSet<Bill> Bills { get; set; }
    public DbSet<BillItem> BillItems { get; set; }
    public DbSet<Payment> Payments { get; set; }
    public DbSet<ReceiptFile> ReceiptFiles { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Organization
        modelBuilder.Entity<Organization>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(200);
            entity.Property(e => e.CreatedAt).IsRequired();
        });

        // User
        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Email).IsRequired().HasMaxLength(255);
            entity.Property(e => e.PasswordHash).IsRequired().HasMaxLength(255);
            entity.Property(e => e.Role).IsRequired().HasMaxLength(50).HasDefaultValue("operator");
            entity.HasIndex(e => e.Email).IsUnique();
            
            entity.HasOne(e => e.Organization)
                .WithMany(o => o.Users)
                .HasForeignKey(e => e.OrganizationId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Customer
        modelBuilder.Entity<Customer>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(200);
            entity.Property(e => e.Contact).HasMaxLength(255);
            
            entity.HasOne(e => e.Organization)
                .WithMany(o => o.Customers)
                .HasForeignKey(e => e.OrganizationId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // Bill
        modelBuilder.Entity<Bill>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.BillNumber).HasMaxLength(100);
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(13,2)").IsRequired();
            entity.Property(e => e.OutstandingAmount).HasColumnType("decimal(13,2)").IsRequired();
            entity.Property(e => e.BillDate).IsRequired();
            entity.Property(e => e.Status).IsRequired().HasMaxLength(20).HasDefaultValue("open");
            
            entity.HasOne(e => e.Organization)
                .WithMany(o => o.Bills)
                .HasForeignKey(e => e.OrganizationId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasOne(e => e.Customer)
                .WithMany(c => c.Bills)
                .HasForeignKey(e => e.CustomerId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasIndex(e => new { e.CustomerId, e.BillDate });
        });

        // BillItem
        modelBuilder.Entity<BillItem>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Description).HasMaxLength(500);
            entity.Property(e => e.Quantity).HasColumnType("decimal(10,2)");
            entity.Property(e => e.UnitPrice).HasColumnType("decimal(13,2)");
            entity.Property(e => e.Amount).HasColumnType("decimal(13,2)");
            
            entity.HasOne(e => e.Bill)
                .WithMany(b => b.Items)
                .HasForeignKey(e => e.BillId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Payment
        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Amount).HasColumnType("decimal(13,2)").IsRequired();
            entity.Property(e => e.PaymentDate).IsRequired();
            entity.Property(e => e.Reference).HasMaxLength(255);
            
            entity.HasOne(e => e.Organization)
                .WithMany(o => o.Payments)
                .HasForeignKey(e => e.OrganizationId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasOne(e => e.Bill)
                .WithMany(b => b.Payments)
                .HasForeignKey(e => e.BillId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasOne(e => e.Customer)
                .WithMany(c => c.Payments)
                .HasForeignKey(e => e.CustomerId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasOne(e => e.ReceiptFile)
                .WithMany(r => r.Payments)
                .HasForeignKey(e => e.ReceiptFileId)
                .OnDelete(DeleteBehavior.SetNull);
            
            entity.HasIndex(e => new { e.BillId, e.PaymentDate });
        });

        // ReceiptFile
        modelBuilder.Entity<ReceiptFile>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.FileUrl).IsRequired().HasMaxLength(1000);
            entity.Property(e => e.Metadata).HasColumnType("jsonb");
            
            entity.HasOne(e => e.Organization)
                .WithMany(o => o.ReceiptFiles)
                .HasForeignKey(e => e.OrganizationId)
                .OnDelete(DeleteBehavior.Restrict);
            
            entity.HasOne(e => e.Uploader)
                .WithMany(u => u.UploadedReceipts)
                .HasForeignKey(e => e.UploadedBy)
                .OnDelete(DeleteBehavior.SetNull);
        });
    }
}

