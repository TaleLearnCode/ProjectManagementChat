using PMC.Common.Data.Models;
using System.Text.Json;

namespace PMC.ProjectDetails;

public class ProjectDetailServices(ProjectDetailServiceOptions options)
{

	private readonly JsonSerializerOptions _jsonSerializerOptions = new() { PropertyNameCaseInsensitive = true };

	public async Task<IEnumerable<ProjectDetail>?> GetProjectDetails()
	{
		HttpRequestMessage request = new()
		{
			Method = HttpMethod.Get,
			RequestUri = options.GetProjectDetailsUrl,
			Headers =
			{
				{ "Ocp-Apim-Subscription-Key", options.SubscriptionKey }
			}
		};
		using HttpResponseMessage response = await options.HttpClient.SendAsync(request);
		response.EnsureSuccessStatusCode();
		var content = await response.Content.ReadAsStringAsync();
		return JsonSerializer.Deserialize<IEnumerable<ProjectDetail>>(content, _jsonSerializerOptions);
	}

}