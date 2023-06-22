dashboard "organization_unsolved_tickets_report" {
  title = "Zendesk Organizations Unsolved Tickets Report"
  documentation = file("./dashboards/organization/docs/organization_report_unsolved_ticket.md")

  tags = merge(local.organization_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.organization_count
      width = 2
    }

    card {
      query = query.ticket_unsolved_count
      width = 2
    }
  }

  container {
    table {
      title = "Organization Unsolved Tickets"
      query = query.organization_unsolved_ticket_table

      column "url" {
        display = "none"
      }

      column "Organization" {
        href = "{{.'url'}}"
      }
    }
  }
}

query "organization_unsolved_ticket_table" {
  sql = <<-EOQ
    with tickets as (
      select
        count(id) as count,
        organization_id
      from
        zendesk_ticket
      where
        status not in ('solved', 'closed')
      group by
        organization_id
    )
    select
      o.name as "Organization",
      t.count as "Unsolved Tickets",
      o.url
    from
      zendesk_organization o
    join tickets t
    on o.id = t.organization_id
    order by
      t.count desc;
  EOQ
}