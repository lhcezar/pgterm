$ ->
  pgterm = $('#console').jqconsole('Hi\n', '$ ')
  Console = ->
    pgterm.Prompt true, ((input) ->

      result = 0
      $.ajax(url: "/query/#{input}").done (ret)->

        #        dataset = new recline.Model.Dataset records: ret
        result = ret
        options = enableColumnReorder: false

        # grid = new Slick.Grid "#display", ret, "d": "dados", options

        pgterm.Write "", 'jqconsole-output'
        grid result
      Console()), ((input) ->
          # execute statement
          if /\;$/.test(input)
            false 
          else 
            -2
      )

    pgterm.RegisterShortcut "R", () ->
      this.Reset()

  Console()

grid = (obj) ->
  # @todo improve hash function
  id = generate_id()

  $('.jqconsole-output:last').append($('<table>', {id: id}))
  
  # @todo very long time when multicolumns are returned
  if obj not instanceof Object
    $("##{id}").append($('<tr>'))
    $("##{id} tbody tr:last").append("<td>#{obj}</td>")
  else
    for i in obj
      $("##{id}").append($('<tr>'))
      for j of i
        $("##{id} tbody tr:last").append("<td>#{i[j]}</td>")

hash = (string) ->
  h = 0
  for i in string
    c = string.charCodeAt i
    h = ((h<<5)-h) + c
    h = h & h

generate_id = (len = 8) ->
  # from coffeescript cookbook
  id = ""
  id += Math.random().toString(32).substr(2) while id.length < len
  id.substr 0, len

