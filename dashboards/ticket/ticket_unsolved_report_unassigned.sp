dashboard "ticket_unassigned_report" {
  title = "Zendesk Unassigned Unsolved Tickets Report"
  documentation = file("./dashboards/ticket/docs/ticket_unsolved_report_unassigned.md")

  tags = merge(local.ticket_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.ticket_unsolved_count
      width = 2
    }

    card {
      query = query.ticket_unsolved_unassigned_count
      width = 2
    }
  }

  container {
    table {
      title = "Unassigned Tickets"
      query = query.ticket_unsolved_unassigned_table

      column "url" {
        display = "none"
      }

      column "org_url" {
        display = "none"
      }

      column "Ticket" {
        href = "{{.'url'}}"
      }

      column "Organization" {
        href = "{{.'org_url'}}"
      }
    }
  }
}

query "ticket_unsolved_unassigned_count" {
  sql = <<-EOQ
    select
      'Unassigned' as label,
      count(*) as value,
      case
        when count(*) > 0 then 'alert'
        else 'ok'
      end as type
    from
      zendesk_ticket
    where
      status not in ('solved', 'closed')
    and
      assignee_id is null;
  EOQ
}

query "ticket_unsolved_unassigned_table" {
  sql = <<-EOQ
    select
      o.name as "Organization",
      t.id || ' ' || t.subject as "Ticket",
      t.status as "Status",
      t.priority as "Priority",
      date_part('day', now() - t.created_at) as "Age in days",
      o.url as org_url,
      t.url
    from
      zendesk_ticket t
    left outer join
      zendesk_organization o
    on
      t.organization_id = o.id
    where
      status not in ('solved', 'closed')
    and
      assignee_id is null
    order by
      "Age in days" desc;
  EOQ
}