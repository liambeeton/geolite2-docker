using System.Threading.Tasks;
using GeoIp.Api.App.Handlers;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;

namespace GeoIp.Api.App.Controllers
{
    [Route(RouteHelper.Index)]
    [ApiVersionNeutral]
    public class IndexController : ControllerBase
    {
        private readonly IWebHostEnvironment _environment;

        public IndexController(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

        [HttpGet]
        public async Task<object> Get([FromHeader(Name ="Content-Type")]string contentTypeHeader)
        {
            if (string.IsNullOrEmpty(contentTypeHeader))
            {
                contentTypeHeader = new StringValues("application/json");
            }
            
            HttpContext.Response.Headers.Add("Content-Type", contentTypeHeader);
            IIndexHandler handler = IndexHandler.GetInstance(contentTypeHeader);
            return await handler.Get(_environment.EnvironmentName, HttpContext);
        }
    }
}