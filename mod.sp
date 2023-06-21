mod "zendesk_insights" {
  # hub metadata
  title         = "Zendesk Insights"
  description   = "Create dashboards and reports for your Zendesk resources using Steampipe."
  color         = "#0089D6"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/zendesk-insights.svg"
  categories    = ["zendesk", "dashboard", "public cloud"]

  opengraph {
    title       = "Steampipe Mod for Zendesk Insights"
    description = "Create dashboards and reports for your Zendesk resources using Steampipe."
    image       = "/images/mods/turbot/zendesk-insights-social-graphic.png"
  }

  require {
    plugin "zendesk" {
      version = "0.6.0"
    }
  }
}