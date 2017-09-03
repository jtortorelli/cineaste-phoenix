// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

$(document).ready(function() {

  // Now that you are connected, you can join channels with a topic:
  let filmChannel = socket.channel("film:lobby", {})
  let peopleChannel = socket.channel("people:lobby", {})
  let filmSearch = $("#film-search-bar")
  let peopleSearch = $("#people-search-bar")
  let filmListsContainer = $("#film-lists")
  let peopleListsContainer = $("#people-lists")

  filmSearch.val('')
  peopleSearch.val('')

  filmSearch.on("keyup", function() {
    delay(function() {
      filmChannel.push("film:filter", {body: filmSearch.val()})
    }, 500);
  })

  peopleSearch.on("keyup", function() {
    delay(function() {
      peopleChannel.push("people:filter", {body: peopleSearch.val()})
    }, 500);
  })

  filmChannel.on("film:filtered", payload => {
    filmListsContainer.html(payload.html)
  })

  peopleChannel.on("people:filtered", payload => {
    peopleListsContainer.html(payload.html)
  })

  var delay = (function() {
    var timer = 0;
    return function(callback, ms) {
      clearTimeout(timer);
      timer = setTimeout(callback, ms);
    };
  })();

  filmChannel.join()
    .receive("ok", resp => { console.log("Joined film channel successfully", resp) })
    .receive("error", resp => { console.log("Unable to join film channel", resp) })

  peopleChannel.join()
    .receive("ok", resp => { console.log("Joined people channel successfully", resp) })
    .receive("error", resp => { console.log("Unable to join people channel", resp) })
})


export default socket
