resource "aws_codecommit_repository" "wild_rides" {
    repository_name = "wild-rides-repo"
    description = "Wild Rides CodeCommit Repository"  
}
output "repository_url" {
  value = aws_codecommit_repository.wild_rides.clone_url_http
  }