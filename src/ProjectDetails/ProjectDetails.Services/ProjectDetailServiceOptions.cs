namespace PMC.ProjectDetails;

public class ProjectDetailServiceOptions
{
	public required HttpClient HttpClient { get; set; }
	public required Uri GetProjectDetailsUrl { get; set; }
	public required string SubscriptionKey { get; set; }
}