namespace GeoIp.Api.App.Controllers
{
    public static class RouteHelper
    {
        public const string Index = "";

        public const string Version = Index + "v{version:apiVersion}/";

        public static class V1
        {
            public const string Swagger = "v1/swagger.json";

            public const string Api = Version;

            public const string WeatherForecast = Version + "weatherforecast/";
        }

        public static class V2
        {
            public const string Swagger = "v2/swagger.json";

            public const string Api = Version;

            public const string WeatherForecast = Version + "weatherforecast/";
        }

        public static string Combine(params string[] routes)
        {
            return string.Join("", routes);
        }
    }
}