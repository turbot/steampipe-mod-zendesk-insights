dashboard "organization_all_ticket_type_report" {
  title = "Zendesk Organizations All Ticket Types Report"
  documentation = file("./dashboards/organization/docs/organization_report_all_ticket_type.md")

  tags = merge(local.organization_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.organization_count
      width = 2
    }

    card {
      query = query.ticket_total_count
      width = 2
    }
  }

  container {
    table {
      title = "Organization All Ticket Types"
      query = query.organization_ticket_type_table

      column "url" {
        display = "none"
      }

      column "Organization" {
        href = "{{.'url'}}"
      }
    }
  }
}

query "organization_ticket_type_table" {
  sql = <<-EOQ
    select
      o.name as "Organization",
      t.type as "Type",
      count(*) as "Count",
      o.url
    from
      zendesk_ticket t
    left outer join
      zendesk_organization o
    on
      t.organization_id = o.id
    group by
      o.name, t.type, o.url
    order by
      o.name, t.type;
  EOQ
}