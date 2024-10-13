using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ProjectDetails.Functions
{
	public class Function1
	{
		private readonly ILogger<Function1> _logger;
		private readonly IConfiguration _configuration;

		public Function1(ILogger<Function1> logger, IConfiguration configuration)
		{
			_logger = logger;
			_configuration = configuration;
		}

		[Function("Function1")]
		public IActionResult Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req)
		{
			_logger.LogInformation("C# HTTP trigger function processed a request.");
			//return new OkObjectResult("Welcome to Azure Functions!");
			return new OkObjectResult(_configuration["containerName"]);
		}
	}
}
