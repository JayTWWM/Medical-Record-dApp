var name;
var password;
var ipfsHash;
var tagFocus = "th";
var checkBox;

function signUp() {
    name = $("#username").val();
    password = $("#pass").val();
    checkBox = document.getElementById("myCheck");
    if (checkBox.checked) {
        console.log("Yes");
    }
    RecordTrackerContract.methods.createIdentity(account0, name, password, checkBox.checked)
        .send()
        .then(result => {
            if (result.status === true) {
                alert("Success");
                console.log(result);
                window.location.href = "./dashboard.html";
            }
        });
}

function login() {
    name = $("#username").val();
    password = $("#pass").val();
    RecordTrackerContract.methods.logInIdentity(account0, name, password)
        .send()
        .then(result => {
            if (result.status === true) {
                alert("Success");
                console.log(result);
                window.location.href = "./dashboard.html";
            }
        });
}

function record() {
    recordName = $("#recordName").val();
    description = $("#desc").val();
    RecordTrackerContract.methods.createRecord(account0, ipfsHash, recordName, description)
        .send()
        .then(result => {
            if (result.status === true) {
                alert("Success");
                console.log(result);
                window.location.href = "./dashboard.html";
            }
        });
}

function getBase64(file) {
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function () {
      console.log(reader.result);
    };
    reader.onerror = function (error) {
      console.log('Error: ', error);
    };
 }

 function upload() {
    const photo = document.getElementById("file");
    const reader = new FileReader();
    reader.readAsBinaryString(photo.files[0]);
    reader.onloadend = function() {
        const ipfs = window.IpfsApi('localhost', 5001) // Connect to IPFS
        var buf = buffer.Buffer.from(reader.result);
        ipfs.files.add(buf, (err, result) => { // Upload buffer to IPFS
            if (err) {
                console.error(err)
                return
            }
            let url = `https://ipfs.io/ipfs/${result[0].hash}`
            console.log(`Url --> ${url}`);
            ipfsHash = result[0].hash;
            console.log(ipfsHash);
        })
    }
  }

function logOut() {
    RecordTrackerContract.methods.logOut(account0)
        .send()
        .then(result => {
            if (result.status === true) {
                alert("Success");
                console.log(result);
                window.location.href = "./index.html";
            }
        });
}

function share() {
    var id = $("#ID").val();
    var un = $("#usernamer").val();
    RecordTrackerContract.methods.shareRecord(account0, id, un)
        .send()
        .then(result => {

            if (result.status === true) {
                alert("Success");
                console.log(result);
                window.location.href = "./dashboard.html";
            }
        });
}

function shiftFocus1() {
    tagFocus = "th";
    $("#searchStatus").html("Search By Owner    ");
    $("#dropdown-content").hide();
}

function shiftFocus2() {
    tagFocus = "h6";
    $("#searchStatus").html("Search By ID    ");
    $("#dropdown-content").hide();
}

function shower() {
    $("#dropdown-content").show();
}

function search() {
    var filter, ul, li, a, i, txtValue;
    filter = $("#search").val().toUpperCase();
    ul = document.getElementById("tbody");
    li = ul.getElementsByTagName("tr");
    for (i = 0; i < li.length; i++) {
        a = li[i].getElementsByTagName(tagFocus)[0];
        txtValue = a.textContent || a.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
            li[i].style.display = "";
        } else {
            li[i].style.display = "none";
        }
    }
}