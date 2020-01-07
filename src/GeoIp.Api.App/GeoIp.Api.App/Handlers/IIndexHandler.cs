using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace GeoIp.Api.App.Handlers
{
    public interface IIndexHandler
    {
        Task<object> Get(string environment, HttpContext context);
    }
}