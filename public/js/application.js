$(document).ready(main);

function main() {
    $(".enviar_al_form_usuario").click(function(e) {
        e.preventDefault();
        $('#carga').fadeIn(5);
        var twitter_handle = $("#myModal").find("textarea").val();
        if (twitter_handle == '') {
            alert("No puedes dejar campos vacios");
        } else {

            setTimeout(function() {
                $(".carga").fadeOut(1000);
            }, 1200);

            $.post('/buscar', {

                twitter_handle: twitter_handle
            }, function(data) {
                $(".profile").remove();
                $(".icon_decoration").remove();
                $(".User_oauth").empty();
                $(".contenidotweet").empty();
                $(".contenidotweet").prepend(data);
            });
            modal.style.display = "none";

        }

    });


    $(".enviar").click(function(c) {
        c.preventDefault();
        var text = $("#myModal2").find("textarea").val();
        if (text == '') {
            alert("No puedes dejar campos vacios");
        } else {
            $.post('/tweet', {
                text: text
            }, function(data) {
              $(".icon_decoration").remove();
                // $(".contenidotweet").empty();
                $(".contenidotweet").prepend(data);
                //  console.log(data);

            });

            modal2.style.display = "none";
        }
    });

// _______________________________________________________________________

    $(".enviar_futuro").click(function(e) {
        e.preventDefault();
        $('#carga').fadeIn(5);
        var texto = $("#myModal3").find("textarea").val();
          var time = $("#myModal3").find(".tiempo").val();

        if (texto  == ''|| time == '') {
            alert("No puedes dejar campos vacios");
        } else {

            setTimeout(function() {
                $(".carga").fadeOut(1000);
            }, 1200);


               $.post("/later/tweet", {
              texto:texto,
              time:time
            }, function(data) {
                var job_id = data;
                var see_status = setInterval(function(){
                  $.get("/status/" + job_id, function(data){
                    // var tarea = JSON.parse(data)
                    //
                    // console.log(typeof tarea.estatus)
                    //
                    // if(tarea.estatus == "incomplete"){
                    //   $("#estatus").html("<div>Existen tweets pendientes</div>")
                    // }else if(tarea.estatus == "complete"){
                    //   $("#estatus").html("<div>No hay tweets pendientes</div>")
                    //   clearInterval(see_status);
                    // }
	                     $("#estatus").text(data);
                  });

                },5000);



            });
    //         $.post('/later/tweet', ser, function(string){
   // 		// ESTAMOS PREGUNTANDO AL SERVIDOR SI YA SE ENVIO, TARDAMOS +3000+ ms EN HACERLO
    //   setTimeout(function(){
		// 		$.get("/status/" + string, function(data) {
		// 			$("#estatus").text(data);
		// 		});
    //   }, 3000);
    // });

            modal3.style.display = "none";

        }

    });




//_________________________NAV
$('.bt-menu').click(function(e) {
    e.preventDefault();

    $('nav#buscame').animate({
        left: "0%"
    });
});

$('.bt-menucross').click(function(e) {
    e.preventDefault();
    $('nav#buscame').animate({
        left: "-100%"
    });
});




    // ____________________MODAL
    var modal = document.getElementById('myModal');

    // Get the button that opens the modal
    var btn = document.getElementById("myBtn");

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];

    btn.onclick = function() {
        modal.style.display = "block";
    }

    // When the user clicks on <span> (x), close the modal
    span.onclick = function() {
        modal.style.display = "none";
    }
// ________________________________________________________
    var modal2 = document.getElementById('myModal2');

    var btn2 = document.getElementById("myBtn2");

    var span2 = document.getElementsByClassName("close2")[0];

    btn2.onclick = function() {
        modal2.style.display = "block";
    }

    span2.onclick = function() {
        modal2.style.display = "none";
    }
// ________________________________________________________

var modal3 = document.getElementById('myModal3');

var btn3 = document.getElementById("myBtn3");

var span3 = document.getElementsByClassName("close3")[0];

btn3.onclick = function() {
    modal3.style.display = "block";
}

span3.onclick = function() {
    modal3.style.display = "none";
}

//__________________________________________________________

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
        if (event.target == modal2) {
            modal2.style.display = "none";
        }
        if (event.target == modal3) {
            modal3.style.display = "none";
        }
    }
}
