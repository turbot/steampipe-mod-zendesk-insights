dashboard "user_2fa_report" {
  title = "Zendesk Users 2FA Report"
  documentation = file("./dashboards/user/docs/user_report_2fa.md")

  tags = merge(local.user_common_tags, {
    type     = "Report"
    category = "Security"
  })

  container {
    card {
      query = query.user_count
      width = 2
    }

    card {
      query = query.user_2fa_disabled_count
      width = 2
    }
  }

  container {
    table {
      title = "Users without 2FA"
      query = query.user_2fa_disabled_table

      column "url" {
        display = "none"
      }

      column "org_url" {
        display = "none"
      }

      column "User" {
        href = "{{.'url'}}"
      }

      column "Organization" {
        href = "{{.'org_url'}}"
      }
    }
  }
}

query "user_2fa_disabled_count" {
  sql = <<-EOQ
    select
      '2fa Disabled' as label,
      count(*) as value,
      case
        when count(*) > 0 then 'alert'
        else 'ok'
      end as type
    from
      zendesk_user
    where
      active
    and
      two_factor_auth_enabled != true;
  EOQ
}

query "user_2fa_disabled_table" {
  sql = <<-EOQ
    select
      o.name as "Organization",
      u.name as "User",
      u.role as "Role",
      u.suspended as "Account Suspended",
      u.two_factor_auth_enabled as "2FA Enabled",
      u.url,
      o.url as org_url
    from
      zendesk_user u
    left outer join
      zendesk_organization o
    on
      u.organization_id = o.id
    where
      u.active
    and
      u.two_factor_auth_enabled != true
    order by
      o.name, u.name;
  EOQ
}