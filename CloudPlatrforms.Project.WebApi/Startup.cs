using System;
using CloudPlatrforms.Project.WebApi.Controllers;
using CloudPlatrforms.Project.WebApi.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace CloudPlatrforms.Project.WebApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            var serviceProvider = services.BuildServiceProvider();
            var logger = serviceProvider.GetService<ILogger<StatisticsController>>();
            logger.LogInformation($"The app is starting. timestamp = {DateTime.UtcNow}");
            services.AddSingleton(typeof(ILogger), logger);

            services.AddControllers();

            var connectionString = Configuration.GetConnectionString("StatisticsDBConnectionString");
            services.AddDbContext<RedditCommentsProjectContext>(options =>
              options.UseSqlServer(connectionString));
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(
            IApplicationBuilder app,
            IWebHostEnvironment env,
            RedditCommentsProjectContext context)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            app.UseErrorHandlerMiddleware();

            context.Database.Migrate();
        }
    }
}
