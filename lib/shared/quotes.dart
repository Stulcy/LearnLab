import 'dart:math';

import 'package:learnlab/models/quote.dart';

class Quotes {
  static final generator = Random();
  static DateTime lastUsed;
  static Quote lastQuote;

  Quote get getRandomQuote {
    // Generate new quote if this is the first request or if it has been
    // more than 5 minutes since previous request
    if (lastQuote == null ||
        DateTime.now().difference(lastUsed).inMinutes >= 5) {
      lastUsed = DateTime.now();
      lastQuote = quotesList[generator.nextInt(quotesList.length)];
    }
    return lastQuote;
  }

  static const List<Quote> quotesList = [
    Quote(
        text: 'All religions, arts and sciences are branches of the same tree.',
        author: 'Albert Einstein'),
    Quote(
        text:
            'Live as if you were to die tomorrow. Learn as if you were to live forever.',
        author: 'Mahatma Gandhi'),
    Quote(
        text: 'An investment in knowledge pays the best interest.',
        author: 'Benjamin Franklin'),
    Quote(
        text: 'Change is the end result of all true learning.',
        author: 'Leo Buscaglia'),
    Quote(
        text:
            'Education is the passport to the future, for tomorrow belongs to those who prepare for it today.',
        author: 'Malcolm X'),
    Quote(
        text: 'The roots of education are bitter, but the fruit is sweet.',
        author: 'Aristotle'),
    Quote(
        text:
            'Education is what remains after one has forgotten what one has learned in school.',
        author: 'Albert Einstein'),
    Quote(
        text:
            'The more that you read, the more things you will know, the more that you learn, the more places you’ll go.',
        author: 'Dr. Seuss'),
    Quote(
        text:
            'Education is not the filling of a pail, but the lighting of a fire.',
        author: 'W.B. Yeats'),
    Quote(
        text:
            'Develop a passion for learning. If you do, you will never cease to grow.',
        author: 'Anthony J. D’Angelo'),
    Quote(
        text:
            'Education is not preparation for life; education is life itself.',
        author: 'John Dewey'),
    Quote(
        text:
            'Knowledge is power. Information is liberating. Education is the premise of progress, in every society, in every family.',
        author: 'Kofi Annan'),
    Quote(
        text:
            'A person who won’t read has no advantage over one who can’t read.',
        author: 'Mark Twain'),
    Quote(
        text:
            'Education is a better safeguard of liberty than a standing army.',
        author: 'Edward Everett'),
    Quote(
        text: 'They know enough who know how to learn.', author: 'Henry Adams'),
    Quote(
        text:
            'Upon the subject of education … I can only say that I view it as the most important subject which we as a people may be engaged in.',
        author: 'Abraham Lincoln'),
    Quote(
        text: 'Nine-tenths of education is encouragement.',
        author: 'Anatole France'),
    Quote(
        text:
            'Man can learn nothing except by going from the known to the unknown.',
        author: 'Claude Bernard'),
    Quote(
        text:
            'Education is the ability to listen to almost anything without losing your temper or your self-confidence.',
        author: 'Robert Frost'),
    Quote(
        text:
            'Learning is not attained by chance, it must be sought for with ardor and attended to with diligence.',
        author: 'Abigail Adams'),
    Quote(
        text:
            'Educating the mind without educating the heart is no education at all.',
        author: 'Aristotle'),
    Quote(
        text:
            'It is as impossible to withhold education from the receptive mind as it is impossible to force it upon the unreasoning.',
        author: 'Agnes Repplierg'),
    Quote(
        text:
            'They cannot stop me. I will get my education, if it is in the home, school, or anyplace.',
        author: 'Malala Yousafzai'),
    Quote(
        text:
            'I was reading the dictionary. I thought it was a poem about everything.',
        author: 'Steven Wright'),
    Quote(
        text:
            'Learning is not the product of teaching. Learning is the product of the activity of learners.',
        author: 'John Holt'),
  ];
}
