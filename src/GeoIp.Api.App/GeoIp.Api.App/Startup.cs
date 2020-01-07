using System.Linq;
using GeoIp.Api.App.Controllers;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Versioning;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;

namespace GeoIp.Api.App
{
    public class Startup
    {
        private const string V1 = "v1";
        private const string V2 = "v2";
        private const string AppTitle = "GeoIP App API";

        private readonly IWebHostEnvironment _environment;

        public Startup(IConfiguration configuration, IWebHostEnvironment environment)
        {
            Configuration = configuration;
            _environment = environment;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services.AddApiVersioning(options =>
            {
                options.ReportApiVersions = true;
                options.DefaultApiVersion = new ApiVersion(1, 0);
            });

            if (_environment.IsDevelopment() || _environment.IsEnvironment("Dev") || _environment.IsEnvironment("QA"))
            {
                services.AddSwaggerGen(options =>
                {
                    options.DocInclusionPredicate((version, apiDescription) =>
                    {
                        if (!apiDescription.ActionDescriptor.Properties.ContainsKey(typeof(ApiVersionModel)))
                        {
                            return false;
                        }

                        var versionModel = apiDescription.ActionDescriptor.Properties[typeof(ApiVersionModel)] as ApiVersionModel;

                        bool result = versionModel.IsApiVersionNeutral ||
                                      versionModel.DeclaredApiVersions.Any(x => $"v{x}" == version) ||
                                      versionModel.DeclaredApiVersions.Count == 0 && versionModel.SupportedApiVersions.Any(x => $"v{x}" == version);

                        if (result)
                        {
                            apiDescription.RelativePath = apiDescription.RelativePath.Replace("v{version}", version);
                        }

                        return result;
                    });

                    //options.IncludeXmlComments(@"GeoIp.Api.App.xml");

                    options.CustomSchemaIds(t => t.FullName);

                    options.SwaggerDoc(V1, new OpenApiInfo
                    {
                        Version = V1,
                        Title = AppTitle
                    });

                    options.SwaggerDoc(V2, new OpenApiInfo
                    {
                        Version = V2,
                        Title = AppTitle
                    });
                });
            }
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
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

            if (_environment.IsDevelopment() || _environment.IsEnvironment("Dev") || _environment.IsEnvironment("QA"))
            {
                app.UseSwagger();
                app.UseSwaggerUI(options =>
                {
                    options.SwaggerEndpoint(RouteHelper.V1.Swagger, $"{AppTitle} {V1}");
                    options.SwaggerEndpoint(RouteHelper.V2.Swagger, $"{AppTitle} {V2}");
                });
            }
        }
    }
}
