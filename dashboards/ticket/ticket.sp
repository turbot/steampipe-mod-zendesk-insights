category "ticket" {
  title = "Ticket"
  icon  = "description"
}

locals {
  ticket_common_tags = {
    service = "Zendesk/Ticket"
  }
}

query "ticket_total_count" {
  sql = <<-EOQ
    select
      count(*) as "Tickets"
    from
      zendesk_ticket;
  EOQ
}

query "ticket_unsolved_count" {
  sql = <<-EOQ
    select
      count(*) as "Unsolved Tickets"
    from
      zendesk_ticket
    where
      status not in ('solved', 'closed');
  EOQ
}