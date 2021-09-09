let admin = require("firebase-admin");

let serviceAccount = require("./admin_key.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const fcm = admin.messaging();

let getUserToken = async (userUid) => {
    const docRef = db.collection("users").doc(userUid);
    return (await docRef.get()).data()["token"];
};

let sendNotification = async (examData, tokens) => {
    console.log("sending to user " + examData["userUid"]);
    // Read token, if not saved already
    if (!tokens[examData["userUid"]]) {
        tokens[examData["userUid"]] = await getUserToken(examData["userUid"]);
        console.log("grabbed");
    }

    const message = {
        notification: {
            title: "hello",
            body: "test",
        },
        token: tokens[examData["userUid"]],
    };

    fcm.send(message);
};

let sendExamNotifications = async () => {
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
    const examsCollecitonRef = db.collection("exams");

    // Izpiti cez 7 dni
    const snapshot7days = await examsCollecitonRef
        .where("date", ">", in7daysLower)
        .where("date", "<", in7daysUpper)
        .get();

    console.log("7 dni\n\n");
    // Posles za cez 1 tedn
    snapshot7days.forEach(async (doc) => {
        await sendNotification(doc.data(), tokens);
    });

    // Izpiti cez 3 dni
    const snapshot3days = await examsCollecitonRef
        .where("date", ">", in3daysLower)
        .where("date", "<", in3daysUpper)
        .get();

    console.log("3 dni\n\n");
    // Posles za cez 3 dni
    snapshot3days.forEach(async (doc) => {
        await sendNotification(doc.data(), tokens);
    });

    // Izpiti cez 1 dan
    const snapshot1day = await examsCollecitonRef
        .where("date", ">", in1dayLower)
        .where("date", "<", in1dayUpper)
        .get();

    console.log("1 dan\n\n");
    // Posles za cez 1 tedn
    snapshot1day.forEach(async (doc) => {
        await sendNotification(doc.data(), tokens);
    });

    console.log(tokens);
};

sendExamNotifications();
console.log("did some nice shit");
