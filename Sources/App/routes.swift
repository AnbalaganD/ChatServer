import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "Hello from Vapor Server (Swift)"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("mqttconfig") { req async throws in
        return MQTTConfig(
            host: "192.168.31.2",
            port: 1883
        )
    }
    
    app.post("login") { req async throws in
        guard let byteBuffer = req.body.data else { throw Abort(.badRequest) }
        
        do {
            let credential = try JSONDecoder().decode(LoginCredential.self, from: byteBuffer)
            if credential.userName == "Anbu",
               credential.password == "1234" {
                return SuccessResponse(
                    statusCode: 200,
                    message: "Success"
                )
            }
            
            throw Abort(.unauthorized)
        } catch {
            throw Abort(.unauthorized)
        }
    }
}

struct MQTTConfig: Content {
    let host: String
    let port: Int
}

struct LoginCredential: Decodable {
    let userName: String
    let password: String
}

struct SuccessResponse: Content {
    let statusCode: Int
    let message: String
}
