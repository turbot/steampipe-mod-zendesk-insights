dashboard "user_unverified_report" {
  title = "Zendesk Unverified Users Report"
  documentation = file("./dashboards/user/docs/user_report_unverified.md")

  tags = merge(local.user_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.user_count
      width = 2
    }

    card {
      query = query.user_unverified_count
      width = 2
    }
  }

  container {
    table {
      title = "Unverified Users"
      query = query.user_unverified_table

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

query "user_unverified_count" {
  sql = <<-EOQ
    select
      'Unverified' as label,
      count(*) as value,
      case
        when count(*) > 0 then 'alert'
        else 'ok'
      end as type
    from
      zendesk_user u
    where
      u.active
    and
      not u.verified;
  EOQ
}

query "user_unverified_table" {
  sql = <<-EOQ
    select
      o.name as "Organization",
      u.name as "User",
      u.role as "Role",
      u.suspended as "Account Suspended",
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
      not u.verified
    order by o.name, u.name;
  EOQ
}