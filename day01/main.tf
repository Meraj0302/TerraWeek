
resource "local_file" "first_terra_file" {
  filename        = "demo_meraj.txt"
  content         = "Hello! Meraj"
  file_permission = "0644"
}