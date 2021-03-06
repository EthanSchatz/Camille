import Bot
import Sugar

final class HelloBot: SlackMessageService {
    override func messageEvent(slackBot: SlackBot, webApi: WebAPI, message: MessageDecorator, previous: MessageDecorator?) throws {
        guard let target = message.target, let sender = message.sender else { return }
        
        try message.routeText(
            to: self.sayHello(to: sender, in: target, with: webApi),
            matching: Greeting(name: "greeting"), slackBot.me
        )
    }
}

fileprivate extension HelloBot {
    func sayHello(to sender: User, in target: SlackTargetType, with webApi: WebAPI) -> (PatternMatchResult) throws -> Void {
        return { match in
            let message = SlackMessage(target: target)
                .text(match.value(named: "greeting"))
                .user(sender)
            
            try webApi.execute(message.apiMethod())
        }
    }
}
