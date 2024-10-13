using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.AzureAppConfiguration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

IHost host = new HostBuilder()



					//.ConfigureAppConfiguration(builder =>
					//{
					//	string cs = Environment.GetEnvironmentVariable("ConnectionString");
					//	builder.AddAzureAppConfiguration(cs);
					//})

					.ConfigureAppConfiguration(builder =>
					{
						builder.AddAzureAppConfiguration(options =>
						{
							options.Connect(Environment.GetEnvironmentVariable("ConnectionString"))
								// Load all keys that start with `TestApp:` and have no label
								//.Select("TestApp:*")
								// Load configuration values with no label
								.Select(KeyFilter.Any, LabelFilter.Null)
								// Override with any configuration values specific to current hosting env
								.Select(KeyFilter.Any, Environment.GetEnvironmentVariable("Environment"))
											// Configure to reload configuration if the registered sentinel key is modified
											.ConfigureRefresh(refreshOptions =>
													refreshOptions.Register("TestApp:Settings:Sentinel", refreshAll: true));
						});
					})

	.ConfigureFunctionsWebApplication()
	.ConfigureServices(services =>
	{
		services.AddApplicationInsightsTelemetryWorkerService();
		services.ConfigureFunctionsApplicationInsights();
		services.AddAzureAppConfiguration();
	})
	.Build();

host.Run();