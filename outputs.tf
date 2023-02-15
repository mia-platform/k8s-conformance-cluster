output "control_plane_public_ip" {
  description = "The public IP for connecting to the cluster control plane"
  value       = google_compute_instance.control_plane.network_interface.0.access_config.0.nat_ip
}
