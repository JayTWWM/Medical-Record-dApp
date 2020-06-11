$.noConflict();

jQuery(document).ready(function($) {
    var recordCount;

    setTimeout(function() {
        RecordTrackerContract.methods.getRecordCount(account0)
            .call((error, response) => {
                if (error) {
                    console.log(error);
                } else {
                    recordCount = response;
                }
            });
        RecordTrackerContract.methods.getUsername(account0)
            .call((error, response) => {
                if (error) {
                    console.log(error);
                } else {
                    let additive = " " + response;
                    $("#heading").append(additive);
                }
            });
    }, 6000);

    setTimeout(function() {
        for (let k = 1; k <= recordCount; k++) {
            RecordTrackerContract.methods.getRecord(account0, k)
                .call((error, response) => {
                    if (error) {
                        console.log(error);
                    } else {
                        let row =
                            "<tr style='background-color: #DCDCDC;'><td><h6>" +
                            k +
                            "</h6></td>" +
                            "<th>" +
                            response[0] +
                            "</th>" +
                            "<td>" +
                            response[1] +
                            "</td>" +
                            "<td>" +
                            response[2] +
                            "</td>" +
                            "<td>" +
                            "<a href='http://127.0.0.1:8080/ipfs/" + response[3] + "' target='_blank' style='color: #1b1b1b'>Get Attachment</a>" +
                            "</td></tr>";

                        $("tbody").append(row);
                    }
                });
        }
    }, 8000)

    "use strict";

    [].slice.call(document.querySelectorAll('select.cs-select')).forEach(function(el) {
        new SelectFx(el);
    });

    jQuery('.selectpicker').selectpicker;


    $('#menuToggle').on('click', function(event) {
        $('body').toggleClass('open');
    });

    $('.search-trigger').on('click', function(event) {
        event.preventDefault();
        event.stopPropagation();
        $('.search-trigger').parent('.header-left').addClass('open');
    });

    $('.search-close').on('click', function(event) {
        event.preventDefault();
        event.stopPropagation();
        $('.search-trigger').parent('.header-left').removeClass('open');
    });


});