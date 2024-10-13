namespace PMC.Common.Data.Models;

public record ProjectDetail
{
	public required string Id { get; set; }
	public required string Name { get; set; }
	public required string Description { get; set; }
}