let admin = require("firebase-admin");

let serviceAccount = require("./admin_key.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});
let admin = require("firebase-admin");

let serviceAccount = require("./admin_key.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const fcm = admin.messaging();

let writeNotification = async(userUid, title, content, date) => {
    const document = await db.collection("home").doc(userUid).get();
    const data = document.data()["notifications"];
    data.push({
        title: title,
        content: content,
        date: new admin.firestore.Timestamp(Math.floor(date / 1000), 0),
    });
    await db.collection("home").doc(userUid).update({
        notifications: data,
    });
};

let getUserToken = async(userUid) => {
    const docRef = db.collection("users").doc(userUid);
    return (await docRef.get()).data()["token"];
};

let sendNotification = async(examData, tokens, days) => {
    console.log("sending to user " + examData["userUid"]);
    // Read token, if not saved already
    if (!tokens[examData["userUid"]]) {
        tokens[examData["userUid"]] = await getUserToken(examData["userUid"]);
        console.log("grabbed");
    }

    let title = "Upcoming " + examData["courseName"] + " exam";
    let content = "";
    if (days == 7) {
        content =
            "You have an exam in one week. Don't forget to start studying if you want to do well on your exam.";
    } else if (days == 3) {
        content =
            "You have 3 days left to study for your exam. There's still plenty of time!";
    } else if (days == 1) {
        content =
            "Hopefully you have gathered all required knowledged for tomorrow's exam. Good luck!";
    }

    writeNotification(examData["userUid"], title, content, Date.now());

    const message = {
        notification: {
            title: title,
            body: content,
        },
        token: tokens[examData["userUid"]],
    };

    fcm.send(message);
};

let sendExamNotifications = async() => {
    const tokens = {};

    // Today's date
    const today = Date.now();
    const todaySeconds = Math.floor(today / 1000);
    const todayTimestamp = new admin.firestore.Timestamp(todaySeconds, 0);

    const in7daysLower = new admin.firestore.Timestamp(
        todaySeconds + 7 * 86400 - 1800,
        0
    );
    const in7daysUpper = new admin.firestore.Timestamp(
        todaySeconds + 7 * 86400 + 1800,
        0
    );

    const in3daysLower = new admin.firestore.Timestamp(
        todaySeconds + 3 * 86400 - 1800,
        0
    );
    const in3daysUpper = new admin.firestore.Timestamp(
        todaySeconds + 3 * 86400 + 1800,
        0
    );

    const in1dayLower = new admin.firestore.Timestamp(
        todaySeconds + 1 * 86400 - 1800,
        0
    );
    const in1dayUpper = new admin.firestore.Timestamp(
        todaySeconds + 1 * 86400 + 1800,
        0
    );

    // Gres cez ceu collection exams
    const examsCollectionRef = db.collection("exams");

    // Izpiti cez 7 dni
    const snapshot7days = await examsCollectionRef
        .where("date", ">", in7daysLower)
        .where("date", "<", in7daysUpper)
        .get();

    console.log("7 dni\n\n");
    // Posles za cez 1 tedn
    snapshot7days.forEach(async(doc) => {
        await sendNotification(doc.data(), tokens, 7);
    });

    // Izpiti cez 3 dni
    const snapshot3days = await examsCollectionRef
        .where("date", ">", in3daysLower)
        .where("date", "<", in3daysUpper)
        .get();

    console.log("3 dni\n\n");
    // Posles za cez 3 dni
    snapshot3days.forEach(async(doc) => {
        await sendNotification(doc.data(), tokens, 3);
    });

    // Izpiti cez 1 dan
    const snapshot1day = await examsCollectionRef
        .where("date", ">", in1dayLower)
        .where("date", "<", in1dayUpper)
        .get();

    console.log("1 dan\n\n");
    // Posles za cez 1 tedn
    snapshot1day.forEach(async(doc) => {
        await sendNotification(doc.data(), tokens, 1);
    });

    console.log(tokens);
};

sendExamNotifications();
console.log("did some nice shit");

const db = admin.firestore();
const fcm = admin.messaging();

let writeNotification = async(userUid, title, content, date) => {
    const document = await db.collection("home").doc(userUid).get();
    const data = document.data()["notifications"];
    data.push({
        title: title,
        content: content,
        date: new admin.firestore.Timestamp(Math.floor(date / 1000), 0),
    });
    await db.collection("home").doc(userUid).update({
        notifications: data,
    });
};

let getUserToken = async(userUid) => {
    const docRef = db.collection("users").doc(userUid);
    return (await docRef.get()).data()["token"];
};

let sendNotification = async(examData, tokens, days) => {
    console.log("sending to user " + examData["userUid"]);
    // Read token, if not saved already
    if (!tokens[examData["userUid"]]) {
        tokens[examData["userUid"]] = await getUserToken(examData["userUid"]);
        console.log("grabbed");
    }

    let title = "Upcoming " + examData["courseName"] + " exam";
    let content = "";
    if (days == 7) {
        content =
            "You have an exam in one week. Don't forget to start studying if you want to do well on your exam.";
    } else if (days == 3) {
        content =
            "You have 3 days left to study for your exam. There's still plenty of time!";
    } else if (days == 1) {
        content =
            "Hopefully you have gathered all required knowledged for tomorrow's exam. Good luck!";
    }

    writeNotification(examData["userUid"], title, content, Date.now());

    const message = {
        notification: {
            title: title,
            body: content,
        },
        token: tokens[examData["userUid"]],
    };

    fcm.send(message);
};

let sendExamNotifications = async() => {
    const tokens = {};

    // Today's date
    const today = Date.now();
    const todaySeconds = Math.floor(today / 1000);
    const todayTimestamp = new admin.firestore.Timestamp(todaySeconds, 0);

    const in7daysLower = new admin.firestore.Timestamp(
        todaySeconds + 7 * 86400 - 1800,
        0
    );
    const in7daysUpper = new admin.firestore.Timestamp(
        todaySeconds + 7 * 86400 + 1800,
        0
    );

    const in3daysLower = new admin.firestore.Timestamp(
        todaySeconds + 3 * 86400 - 1800,
        0
    );
    const in3daysUpper = new admin.firestore.Timestamp(
        todaySeconds + 3 * 86400 + 1800,
        0
    );

    const in1dayLower = new admin.firestore.Timestamp(
        todaySeconds + 1 * 86400 - 1800,
        0
    );
    const in1dayUpper = new admin.firestore.Timestamp(
        todaySeconds + 1 * 86400 + 1800,
        0
    );

    // Gres cez ceu collection exams
    const examsCollectionRef = db.collection("exams");

    // Izpiti cez 7 dni
    const snapshot7days = await examsCollectionRef
        .where("date", ">", in7daysLower)
        .where("date", "<", in7daysUpper)
        .get();

    console.log("7 dni\n\n");
    // Posles za cez 1 tedn
    snapshot7days.forEach(async(doc) => {
        await sendNotification(doc.data(), tokens, 7);
    });

    // Izpiti cez 3 dni
    const snapshot3days = await examsCollectionRef
        .where("date", ">", in3daysLower)
        .where("date", "<", in3daysUpper)
        .get();

    console.log("3 dni\n\n");
    // Posles za cez 3 dni
    snapshot3days.forEach(async(doc) => {
        await sendNotification(doc.data(), tokens, 3);
    });

    // Izpiti cez 1 dan
    const snapshot1day = await examsCollectionRef
        .where("date", ">", in1dayLower)
        .where("date", "<", in1dayUpper)
        .get();

    console.log("1 dan\n\n");
    // Posles za cez 1 tedn
    snapshot1day.forEach(async(doc) => {
        await sendNotification(doc.data(), tokens, 1);
    });

    console.log(tokens);
};

sendExamNotifications();
console.log("did some nice shit");