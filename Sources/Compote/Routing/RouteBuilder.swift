@_functionBuilder
public enum RouteBuilder {
    public static func buildBlock<R>(_ route: R) -> Router where R: Route {
        var router = Router()
        router.append(route)
        return router
    }

    public static func buildBlock<R0, R1>(
        _ route0: R0,
        _ route1: R1
    ) -> Router where R0: Route, R1: Route {
        var router = Router()
        router.append(route0)
        router.append(route1)
        return router
    }

    public static func buildBlock<R0, R1, R2>(
        _ route0: R0,
        _ route1: R1,
        _ route2: R2
    ) -> Router where R0: Route, R1: Route, R2: Route {
        var router = Router()
        router.append(route0)
        router.append(route1)
        router.append(route2)
        return router
    }

    public static func buildBlock<R0, R1, R2, R3>(
        _ route0: R0,
        _ route1: R1,
        _ route2: R2,
        _ route3: R3
    ) -> Router where R0: Route, R1: Route, R2: Route, R3: Route {
        var router = Router()
        router.append(route0)
        router.append(route1)
        router.append(route2)
        router.append(route3)
        return router
    }

    public static func buildBlock<R0, R1, R2, R3, R4>(
        _ route0: R0,
        _ route1: R1,
        _ route2: R2,
        _ route3: R3,
        _ route4: R4
    ) -> Router where R0: Route, R1: Route, R2: Route, R3: Route, R4: Route {
        var router = Router()
        router.append(route0)
        router.append(route1)
        router.append(route2)
        router.append(route3)
        router.append(route4)
        return router
    }

    public static func buildBlock<R0, R1, R2, R3, R4, R5>(
        _ route0: R0,
        _ route1: R1,
        _ route2: R2,
        _ route3: R3,
        _ route4: R4,
        _ route5: R5
    ) -> Router where R0: Route, R1: Route, R2: Route, R3: Route, R4: Route, R5: Route {
        var router = Router()
        router.append(route0)
        router.append(route1)
        router.append(route2)
        router.append(route3)
        router.append(route4)
        router.append(route5)
        return router
    }

    public static func buildBlock<R0, R1, R2, R3, R4, R5, R6>(
        _ route0: R0,
        _ route1: R1,
        _ route2: R2,
        _ route3: R3,
        _ route4: R4,
        _ route5: R5,
        _ route6: R6
    ) -> Router where R0: Route, R1: Route, R2: Route, R3: Route, R4: Route, R5: Route, R6: Route {
        var router = Router()
        router.append(route0)
        router.append(route1)
        router.append(route2)
        router.append(route3)
        router.append(route4)
        router.append(route5)
        router.append(route6)
        return router
    }
}
