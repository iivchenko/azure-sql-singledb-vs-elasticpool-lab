﻿using Microsoft.EntityFrameworkCore;

namespace Lab.Api
{
    public class PostContext : DbContext
    {
        public PostContext(DbContextOptions<PostContext> options) 
            : base(options)
        {
        }

        public DbSet<Post> Posts { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Post>().ToTable("Posts");
        }
    }
}
