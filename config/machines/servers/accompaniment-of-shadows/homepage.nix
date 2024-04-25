{ config, pkgs, ... }: {
  services.homepage-dashboard = {
    enable = true;
    listenPort = 3000;
    environmentFile = "/etc/homepage.env";

    settings = {
      layout = {
        Organization = {
          style = "row";
          columns = 2;
        };
      };
    };

    bookmarks = [
      {
        Homelab = [{
          Tailscale = [{
            abbr = "TS";
            href = "https://login.tailscale.com/admin/machines";
          }];
        }];
      }
      {
        Social = [
          {
            "Hacker News" = [{
              abbr = "HN";
              href = "https://news.ycombinator.com";
            }];
          }
          {
            YouTube = [{
              abbr = "YT";
              href = "https://youtube.com/";
            }];
          }
          {
            "Last.fm" = [{
              abbr = "FM";
              href = "https://last.fm";
            }];
          }
          {
            "Listen Brainz" = [{
              abbr = "LB";
              href = "https://listenbrainz.org/user/b7r6";
            }];
          }
        ];
      }
    ];

    services = [ ];

    widgets = [
      {
        datetime = {
          text_size = "xl";
          format = {
            dateStyle = "long";
            timeStyle = "short";
            hour12 = false;
          };
        };
      }
      {
        search = {
          provider = "google";
          target = "_blank";
        };
      }
      {
        openmeteo = {
          label = "Los Angeles";
          latitude = 34.25193046871679;
          longitude = -118.37664240064478;
          timezone = "America/Los_Angeles";
          units = "metric"; # or imperial
          cache =
            5; # Time in minutes to cache API responses, to stay within limits
        };
      }
    ];
  };

  systemd.services.homepage-dashboard = {
    serviceConfig = { DynamicUser = pkgs.lib.mkOverride 10 false; };
  };

  environment.etc."homepage.env".text = ''
    # Organization
    HOMEPAGE_FILE_HOMEBOX_PASSWORD=${config.sops.secrets.homebox-password.path}

    # Media
    HOMEPAGE_FILE_JELLYSEER_KEY=${config.sops.secrets.jellyseer-key.path}
    HOMEPAGE_FILE_JELLYFIN_KEY=${config.sops.secrets.jellyfin-key.path}
    HOMEPAGE_FILE_NAVIDROME_TOKEN=${config.sops.secrets.navidrome-token.path}
    HOMEPAGE_FILE_NAVIDROME_SALT=${config.sops.secrets.navidrome-salt.path}
    HOMEPAGE_FILE_IMMICH_KEY=${config.sops.secrets.immich-key.path}
    HOMEPAGE_FILE_TUBEARCHIVIST_KEY=${config.sops.secrets.TubeArchivist-key.path}

    # File Management
    HOMEPAGE_FILE_QBITTORRENT_PASSWORD=${config.sops.secrets.qBittorrent-password.path}
    HOMEPAGE_FILE_LIDARR_KEY=${config.sops.secrets.lidarr-key.path}
    HOMEPAGE_FILE_RADARR_KEY=${config.sops.secrets.radarr-key.path}
    HOMEPAGE_FILE_PROWLARR_KEY=${config.sops.secrets.prowlarr-key.path}
    HOMEPAGE_FILE_SABNZBD_KEY=${config.sops.secrets.sabnzbd-key.path}

    # Infrastructure
    HOMEPAGE_FILE_TRUENAS_KEY=${config.sops.secrets.truenas-key.path}
  '';

  sops.secrets = {
    homebox-password = { };

    jellyseer-key = { };
    jellyfin-key = { };
    navidrome-token = { };
    navidrome-salt = { };
    immich-key = { };
    TubeArchivist-key = { };

    qBittorrent-password = { };
    lidarr-key = { };
    radarr-key = { };
    prowlarr-key = { };
    sabnzbd-key = { };
    truenas-key = { };
  };

  services.nginx.virtualHosts."homepage.service" = {
    locations."/".proxyPass = "http://localhost:3000";
  };
}

