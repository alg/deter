# Notifications box
@NotificationsBox = React.createClass
  getInitialState: ->
    items = gon.notifications || []
    items = items.map (n) ->
      n.parsedTime = moment(n.time, 'YYYYMMDDTHHmmssZ')
      return n

    return { items: items, hideOld: false }

  handleHideOldChange: ->
    state = this.state
    state.hideOld = !state.hideOld
    this.setState(state)

  render: ->
    if this.state.items.length > 0 and !this.props.no_old_hiding
      controls = `<NotificationsControls hideOld={this.state.hideOld} onHideOldChange={this.handleHideOldChange} />`

    # filter
    filtered = []
    if this.state.hideOld
      threshold = moment().subtract(gon.old_threshold_days, 'days')
      this.state.items.forEach (n) ->
        if !n.read and n.parsedTime.isAfter(threshold)
          filtered.push(n)
    else
      filtered = this.state.items

    # new projects and most recent first
    sorted = filtered.sort (a, b) ->
      aNewProj = a.type == gon.new_project_type and !a.read
      bNewProj = b.type == gon.new_project_type and !b.read

      if aNewProj == bNewProj
        return if a.parsedTime.isAfter(b.parsedTime) then -1 else 1
      else if aNewProj
        return -1
      else
        return 1

    if sorted.length == 0
      list = `<NoNotifications msg={this.props.nothing_text} />`
    else
      list = `<NotificationsList items={sorted} />`

    `<div>{controls}{list}</div>`

@NotificationsControls = React.createClass
  render: ->
    `<div className='row'>
      <div className='col-sm-12'>
        <div className='checkbox'>
          <label>
            <input type='checkbox' checked={this.props.hideOld} onChange={this.props.onHideOldChange} />
            Hide old notifications
          </label>
        </div>
      </div>
     </div>`

# No notifications message
@NoNotifications = React.createClass
  render: ->
    `<div className='row'>
      <div className='col-sm-12'>
        <p>{this.props.msg}</p>
      </div>
    </div>`

# Notifications list
@NotificationsList = React.createClass
  render: ->
    rows = this.props.items.map (n) ->
      return `<NotificationRow key={n.id} data={n} />`

    `<div className='row'>
      <div className='col-sm-12'>
        <table className='table table-striped'>
          <tbody>
            {rows}
          </tbody>
        </table>
      </div>
    </div>`

# Single notification row
@NotificationRow = React.createClass
  getInitialState: ->
    { collapsed: true }

  handleToggle: (e) ->
    e.preventDefault()
    state = this.state
    state.collapsed = !state.collapsed
    this.setState(state)

    if !this.props.data.read && !state.collapsed
      this.requestMarkingAsRead()

  requestMarkingAsRead: ->
    $.post(gon.mark_as_read_path.replace(':id', this.props.data.id))

  render: ->
    n = this.props.data

    time = moment(n.time, 'YYYYMMDDTHHmmssZ').format('YYYY-MM-DD h:mm:ss a')

    if n.urgent
      urgent = `<div className='col-sm-2 text-right'>Urgent</div>`

    status = if n.read then 'Old' else if n.urgent then 'Urgent' else 'New'

    if this.state.collapsed
      controls= `<a href='#' onClick={this.handleToggle} className='btn btn-xs btn-default'>Show</a>`
      content = ''
    else
      controls= `<a href='#' onClick={this.handleToggle} className='btn btn-xs btn-default'>Hide</a>`
      body = { __html: n.body }
      content = `<div dangerouslySetInnerHTML={body} />`


    `<tr>
      <td>
        <div className='pull-right'>{controls}</div>
        <div className='row'>
          <div className='col-sm-1'>Sender:</div>
          <div className='col-sm-9'>{n.sender}</div>
        </div>
        <div className='row'>
          <div className='col-sm-1'>Date:</div>
          <div className='col-sm-11'>{time}</div>
        </div>
        <div className='row'>
          <div className='col-sm-1'>Status:</div>
          <div className='col-sm-11'>{status}</div>
        </div>
        <div className='row'>
          <div className='col-sm-1'>Type:</div>
          <div className='col-sm-11'>{n.type}</div>
        </div>
        <div className='row'>
          <div className='col-sm-12'>{content}</div>
        </div>
      </td>
     </tr>`
