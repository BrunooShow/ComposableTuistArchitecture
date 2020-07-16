import Foundation
import ComposableTuistArchitectureSupport
import ComposableArchitecture
import Combine

public struct AddRecipeFeatureEnvironment {
    public init(
        cookbookClient: CookbookClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.cookbookClient = cookbookClient
        self.mainQueue = mainQueue
    }
    
    let cookbookClient: CookbookClient
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

public let addRecipeFeatureReducer = Reducer<AddRecipeFeatureState, AddRecipeFeatureAction, AddRecipeFeatureEnvironment>.combine(
  addRecipeReducer.pullback(
    state: \.addRecipe,
    action: /AddRecipeFeatureAction.addRecipe,
    environment: {
        AddRecipeEnvironment(
            cookbookClient: $0.cookbookClient,
            mainQueue: $0.mainQueue
        )
    }
  )
)

public enum AddRecipeFeatureAction {
    case addRecipe(AddRecipeAction)
}

public typealias AddRecipeScreenState = (
    name: String,
    currentIngredient: String,
    ingredients: [String]
)

public struct AddRecipeFeatureState {
    public init(
        recipes: IdentifiedArrayOf<Recipe> = [],
        isShowingAddRecipe: Bool = true,
        addRecipeScreenState: AddRecipeScreenState = ("", "", [])
    ) {
        self.recipes = recipes
        self.isShowingAddRecipe = isShowingAddRecipe
        self.addRecipeScreenState = addRecipeScreenState
    }
    
    public var recipes: IdentifiedArrayOf<Recipe>
    public var isShowingAddRecipe: Bool
    public var addRecipeScreenState: AddRecipeScreenState
    
    var addRecipe: AddRecipeState {
        get {
            AddRecipeState(
                name: addRecipeScreenState.name,
                currentIngredient: addRecipeScreenState.currentIngredient,
                ingredients: addRecipeScreenState.ingredients,
                recipes: recipes,
                isShowingAddRecipe: isShowingAddRecipe
            )     
        }
        set {
            addRecipeScreenState.name = newValue.name
            addRecipeScreenState.currentIngredient = newValue.currentIngredient
            addRecipeScreenState.ingredients = newValue.ingredients
            recipes = newValue.recipes
            isShowingAddRecipe = newValue.isShowingAddRecipe
        }
    }
}
