require "mrsk/cli/base"

class Mrsk::Cli::Traefik < Mrsk::Cli::Base
  desc "boot", "Boot Traefik on servers"
  def boot
    on(MRSK.traefik_hosts) { execute *MRSK.traefik.run, raise_on_non_zero_exit: false }
  end

  desc "reboot", "Reboot Traefik on servers"
  def reboot
    invoke :stop
    invoke :remove_container
    invoke :boot
  end

  desc "start", "Start existing Traefik on servers"
  def start
    on(MRSK.traefik_hosts) { execute *MRSK.traefik.start, raise_on_non_zero_exit: false }
  end

  desc "stop", "Stop Traefik on servers"
  def stop
    on(MRSK.traefik_hosts) { execute *MRSK.traefik.stop, raise_on_non_zero_exit: false }
  end

  desc "restart", "Restart Traefik on servers"
  def restart
    invoke :stop
    invoke :start
  end

  desc "details", "Display details about Traefik containers from servers"
  def details
    on(MRSK.traefik_hosts) { |host| puts_by_host host, capture_with_info(*MRSK.traefik.info), type: "Traefik" }
  end

  desc "logs", "Show log lines from Traefik on servers"
  option :since, aliases: "-s", desc: "Show logs since timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)"
  option :lines, type: :numeric, aliases: "-n", desc: "Number of log lines to pull from each server"
  def logs
    since = options[:since]
    lines = options[:lines]

    on(MRSK.traefik_hosts) { |host| puts_by_host host, capture(*MRSK.traefik.logs(since: since, lines: lines)), type: "Traefik" }
  end

  desc "remove", "Remove Traefik container and image from servers"
  def remove
    invoke :stop
    invoke :remove_container
    invoke :remove_image
  end

  desc "remove_container", "Remove Traefik container from servers"
  def remove_container
    on(MRSK.traefik_hosts) { execute *MRSK.traefik.remove_container }
  end

  desc "remove_container", "Remove Traefik image from servers"
  def remove_image
    on(MRSK.traefik_hosts) { execute *MRSK.traefik.remove_image }
  end
end
