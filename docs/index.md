---
repository: "https://github.com/turbot/steampipe-mod-zendesk-insights"
---

# Zendesk Insights Mod

Create dashboards and reports for your Zendesk organizations, tickets, etc using Steampipe.

## Overview

Dashboards can help answer questions like:

- How old are the unresolved tickets?
- Which organizations have opened the most tickets?
- Are users following 2fa best practices?

## References

[Zendesk](https://www.zendesk.com/) is a customer service SaaS platform with 200,000+ customers. It enables organizations to provide customer service via text, mobile, phone, email, live chat, social media.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration, and `dashboards` that organize and display key pieces of information.

## Documentation

- **[Dashboards →](https://hub.steampipe.io/mods/turbot/zendesk_insights/dashboards)**

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the Zendesk plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install zendesk
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-zendesk-insights.git
cd steampipe-mod-zendesk-insights
```

### Usage

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser window at https://localhost:9194. From here, you can view dashboards and reports.

### Credentials

This mod uses the credentials configured in the [Steampipe Zendesk plugin](https://hub.steampipe.io/plugins/turbot/zendesk).

### Configuration

No extra configuration is required.

## Contributing

If you have an idea for additional dashboards or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-github-insights/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Zendesk Insights Mod](https://github.com/turbot/steampipe-mod-zendesk-insights/labels/help%20wanted)