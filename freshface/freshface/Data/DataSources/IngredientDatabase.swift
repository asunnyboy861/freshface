import Foundation

/// Built-in ingredient database
/// Contains safety information for common skincare ingredients
/// Design principle: Static data, loaded at app launch, supports future cloud updates
class IngredientDatabase {
    static let shared = IngredientDatabase()
    
    private var ingredients: [Ingredient] = []
    private var nameIndex: [String: Ingredient] = [:]      // Name index
    private var aliasIndex: [String: Ingredient] = [:]     // Alias index
    
    private init() {
        loadDefaultIngredients()
        buildIndexes()
    }
    
    // MARK: - Public API
    
    /// Find ingredient by name
    func findIngredient(byName name: String) -> Ingredient? {
        let normalizedName = normalize(name)
        return nameIndex[normalizedName] ?? aliasIndex[normalizedName]
    }
    
    /// Search ingredients (supports partial matching)
    func searchIngredients(query: String) -> [Ingredient] {
        let normalizedQuery = normalize(query)
        return ingredients.filter { ingredient in
            normalize(ingredient.name).contains(normalizedQuery) ||
            ingredient.aliases.contains { normalize($0).contains(normalizedQuery) }
        }
    }
    
    /// Get all ingredients
    func getAllIngredients() -> [Ingredient] {
        return ingredients
    }
    
    /// Filter by safety rating
    func getIngredients(byRating rating: SafetyRating) -> [Ingredient] {
        return ingredients.filter { $0.safetyRating == rating }
    }
    
    /// Filter by concern
    func getIngredients(byConcern concern: SafetyConcern) -> [Ingredient] {
        return ingredients.filter { $0.concerns.contains(concern) }
    }
    
    // MARK: - Private Methods
    
    private func normalize(_ string: String) -> String {
        return string.lowercased().trimmingCharacters(in: .whitespaces)
    }
    
    private func buildIndexes() {
        nameIndex.removeAll()
        aliasIndex.removeAll()
        
        for ingredient in ingredients {
            nameIndex[normalize(ingredient.name)] = ingredient
            for alias in ingredient.aliases {
                aliasIndex[normalize(alias)] = ingredient
            }
        }
    }
    
    // MARK: - Default Data Loading
    
    private func loadDefaultIngredients() {
        // High Risk Ingredients - Preservatives
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Paraben",
                description: "A group of synthetic compounds commonly used as preservatives in cosmetics and personal care products.",
                safetyRating: .concerning,
                concerns: [.endocrineDisruptor, .environmental],
                categories: [.preservative],
                aliases: ["Methylparaben", "Propylparaben", "Butylparaben", "Ethylparaben", "Isobutylparaben"]
            ),
            Ingredient(
                name: "Formaldehyde",
                description: "A colorless gas used as a preservative and disinfectant. Known carcinogen.",
                safetyRating: .unsafe,
                concerns: [.carcinogen, .skinIrritant, .allergen],
                categories: [.preservative],
                aliases: ["Formalin", "Methanal", "Formic aldehyde"]
            ),
            Ingredient(
                name: "DMDM Hydantoin",
                description: "A formaldehyde-releasing preservative used in cosmetics.",
                safetyRating: .concerning,
                concerns: [.allergen, .skinIrritant],
                categories: [.preservative],
                aliases: ["DMDM hydantoin", "1,3-dimethylol-5,5-dimethyl hydantoin"]
            ),
            Ingredient(
                name: "Imidazolidinyl Urea",
                description: "A formaldehyde-releasing preservative that can cause skin irritation.",
                safetyRating: .concerning,
                concerns: [.allergen, .skinIrritant],
                categories: [.preservative],
                aliases: ["Imidurea", "Germall 115"]
            ),
            Ingredient(
                name: "Quaternium-15",
                description: "A formaldehyde-releasing preservative and known allergen.",
                safetyRating: .concerning,
                concerns: [.allergen, .skinIrritant],
                categories: [.preservative],
                aliases: ["Dowicil 200"]
            )
        ])
        
        // Surfactants
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Sodium Lauryl Sulfate",
                description: "A surfactant used for its cleaning and emulsifying properties. Can be irritating to skin.",
                safetyRating: .moderate,
                concerns: [.skinIrritant],
                categories: [.surfactant],
                aliases: ["SLS", "Sodium dodecyl sulfate", "Sulfuric acid monododecyl ester sodium salt"]
            ),
            Ingredient(
                name: "Sodium Laureth Sulfate",
                description: "A gentler alternative to SLS, but may be contaminated with 1,4-dioxane.",
                safetyRating: .moderate,
                concerns: [.skinIrritant],
                categories: [.surfactant],
                aliases: ["SLES", "Sodium lauryl ether sulfate"]
            ),
            Ingredient(
                name: "Ammonium Lauryl Sulfate",
                description: "A surfactant similar to SLS that can cause skin and eye irritation.",
                safetyRating: .moderate,
                concerns: [.skinIrritant],
                categories: [.surfactant],
                aliases: ["ALS"]
            ),
            Ingredient(
                name: "Cocamidopropyl Betaine",
                description: "A surfactant derived from coconut oil, generally well-tolerated but can cause allergic reactions in some.",
                safetyRating: .safe,
                concerns: [.allergen],
                categories: [.surfactant],
                aliases: ["CAPB", "Cocamidopropyl dimethyl glycine"]
            )
        ])
        
        // Safe Ingredients
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Hyaluronic Acid",
                description: "A naturally occurring substance in the body that helps retain moisture in skin.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.humectant, .activeIngredient],
                aliases: ["HA", "Sodium hyaluronate", "Hyaluronan"]
            ),
            Ingredient(
                name: "Niacinamide",
                description: "A form of vitamin B3 that helps build keratin and keeps skin firm and healthy.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient, .antioxidant],
                aliases: ["Vitamin B3", "Nicotinamide", "Nicotinic acid amide"]
            ),
            Ingredient(
                name: "Ceramide",
                description: "Naturally occurring lipids that help form the skin's barrier and retain moisture.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient],
                aliases: ["Ceramides", "Ceramide NP", "Ceramide AP", "Ceramide EOP"]
            ),
            Ingredient(
                name: "Glycerin",
                description: "A humectant that draws moisture to the skin. Very well-tolerated.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.humectant],
                aliases: ["Glycerol", "Propane-1,2,3-triol"]
            ),
            Ingredient(
                name: "Squalane",
                description: "A lightweight, non-comedogenic oil that mimics skin's natural sebum.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient],
                aliases: ["Perhydrosqualene"]
            ),
            Ingredient(
                name: "Centella Asiatica",
                description: "A plant extract known for its soothing and healing properties.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient, .antioxidant],
                aliases: ["Cica", "Gotu Kola", "Asiatic pennywort"]
            ),
            Ingredient(
                name: "Retinol",
                description: "A form of vitamin A that promotes cell turnover and collagen production.",
                safetyRating: .safe,
                concerns: [.skinIrritant],
                categories: [.activeIngredient],
                aliases: ["Vitamin A", "Retinoid"]
            ),
            Ingredient(
                name: "Vitamin C",
                description: "A powerful antioxidant that brightens skin and boosts collagen.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient, .antioxidant],
                aliases: ["Ascorbic Acid", "L-Ascorbic Acid", "Sodium Ascorbyl Phosphate"]
            ),
            Ingredient(
                name: "Peptides",
                description: "Short chains of amino acids that help build proteins in the skin.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Polypeptides", "Copper Peptides", "Matrixyl"]
            ),
            Ingredient(
                name: "Green Tea Extract",
                description: "Rich in antioxidants, helps protect skin from environmental damage.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.antioxidant, .activeIngredient],
                aliases: ["Camellia Sinensis", "EGCG", "Tea Polyphenols"]
            )
        ])
        
        // Fragrance/Colorants
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Fragrance",
                description: "A mixture of chemicals that give products their scent. Often contains allergens.",
                safetyRating: .moderate,
                concerns: [.allergen, .skinIrritant],
                categories: [.fragrance],
                aliases: ["Parfum", "Perfume", "Aroma", "Essential oil blend"]
            ),
            Ingredient(
                name: "Synthetic Color",
                description: "Artificial dyes used to color cosmetics. Some may be derived from coal tar.",
                safetyRating: .moderate,
                concerns: [.skinIrritant],
                categories: [.colorant],
                aliases: ["FD&C", "D&C", "Lake", "CI 15850", "CI 19140"]
            ),
            Ingredient(
                name: "Phthalates",
                description: "Chemicals used to make fragrances last longer. Potential endocrine disruptors.",
                safetyRating: .concerning,
                concerns: [.endocrineDisruptor, .environmental],
                categories: [.fragrance, .solvent],
                aliases: ["DEP", "DBP", "DMP", "Diethyl phthalate"]
            ),
            Ingredient(
                name: "Mineral Oil",
                description: "A byproduct of petroleum distillation. Can clog pores in some skin types.",
                safetyRating: .safe,
                concerns: [],
                categories: [.emollient],
                aliases: ["Paraffinum Liquidum", "Petrolatum", "White mineral oil"]
            ),
            Ingredient(
                name: "Petrolatum",
                description: "A semi-solid mixture of hydrocarbons used as a moisturizer. Generally safe but derived from petroleum.",
                safetyRating: .safe,
                concerns: [.environmental],
                categories: [.emollient],
                aliases: ["Petroleum jelly", "Vaseline", "Mineral jelly"]
            )
        ])
        
        // Sunscreen ingredients
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Oxybenzone",
                description: "A chemical sunscreen agent that absorbs UVB and UVA rays. Potential hormone disruptor.",
                safetyRating: .concerning,
                concerns: [.endocrineDisruptor, .environmental],
                categories: [.uvFilter],
                aliases: ["Benzophenone-3", "BP-3"]
            ),
            Ingredient(
                name: "Octinoxate",
                description: "A chemical UV filter that may have hormone-disrupting effects.",
                safetyRating: .moderate,
                concerns: [.endocrineDisruptor, .environmental],
                categories: [.uvFilter],
                aliases: ["Ethylhexyl methoxycinnamate", "OMC"]
            ),
            Ingredient(
                name: "Zinc Oxide",
                description: "A mineral sunscreen that provides broad-spectrum protection. Very safe.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.uvFilter],
                aliases: ["ZnO", "Physical sunscreen"]
            ),
            Ingredient(
                name: "Titanium Dioxide",
                description: "A mineral sunscreen and whitening agent. Generally recognized as safe.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.uvFilter, .colorant],
                aliases: ["TiO2", "CI 77891"]
            )
        ])
        
        // Alcohols
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Denatured Alcohol",
                description: "Alcohol that has been made unfit for drinking. Can be drying to skin.",
                safetyRating: .moderate,
                concerns: [.skinIrritant],
                categories: [.solvent],
                aliases: ["Alcohol Denat", "SD Alcohol", "Ethanol"]
            ),
            Ingredient(
                name: "Benzyl Alcohol",
                description: "A naturally occurring and synthetic ingredient used as preservative and solvent.",
                safetyRating: .safe,
                concerns: [.allergen],
                categories: [.preservative, .solvent],
                aliases: ["Phenylmethanol"]
            ),
            Ingredient(
                name: "Cetyl Alcohol",
                description: "A fatty alcohol used as an emollient and emulsifier. Non-irritating.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient, .emulsifier],
                aliases: ["Palmityl alcohol", "Hexadecanol"]
            ),
            Ingredient(
                name: "Stearyl Alcohol",
                description: "A fatty alcohol that helps form emulsions and soften skin.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient, .emulsifier],
                aliases: ["Stearol", "Octadecanol"]
            )
        ])

        // MARK: - Extended Ingredient Database (50+ additional ingredients)

        // Moisturizing Ingredients (Humectants & Emollients)
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Butylene Glycol",
                description: "A humectant and penetration enhancer that helps moisturize skin.",
                safetyRating: .safe,
                concerns: [],
                categories: [.humectant],
                aliases: ["1,3-Butylene Glycol", "BDO"]
            ),
            Ingredient(
                name: "Propylene Glycol",
                description: "A humectant that helps ingredients penetrate skin. Generally safe but may irritate sensitive skin.",
                safetyRating: .moderate,
                concerns: [.skinIrritant],
                categories: [.humectant],
                aliases: ["1,2-Propanediol", "PG"]
            ),
            Ingredient(
                name: "Caprylic/Capric Triglyceride",
                description: "A lightweight emollient derived from coconut oil. Non-greasy and easily absorbed.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient],
                aliases: ["MCT Oil", "Medium Chain Triglyceride"]
            ),
            Ingredient(
                name: "Isopropyl Myristate",
                description: "An emollient that gives products a smooth, non-greasy feel. Can be comedogenic.",
                safetyRating: .moderate,
                concerns: [.skinIrritant],
                categories: [.emollient],
                aliases: ["IPM"]
            ),
            Ingredient(
                name: "Coconut Oil",
                description: "A popular emollient with antimicrobial properties. Can clog pores in some individuals.",
                safetyRating: .safe,
                concerns: [],
                categories: [.emollient],
                aliases: ["Cocos Nucifera Oil", "Virgin Coconut Oil"]
            ),
            Ingredient(
                name: "Shea Butter",
                description: "A rich emollient with anti-inflammatory properties. Excellent for dry skin.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient],
                aliases: ["Butyrospermum Parkii", "Karite Butter"]
            ),
            Ingredient(
                name: "Jojoba Oil",
                description: "A liquid wax similar to skin's natural sebum. Non-comedogenic and moisturizing.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient],
                aliases: ["Simmondsia Chinensis", "Jojoba Wax"]
            ),
            Ingredient(
                name: "Argan Oil",
                description: "A nourishing oil rich in vitamin E and fatty acids. Great for anti-aging.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient, .antioxidant],
                aliases: ["Argania Spinosa", "Moroccan Oil"]
            ),
            Ingredient(
                name: "Sodium PCA",
                description: "A natural moisturizing factor that holds water in the skin.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.humectant],
                aliases: ["Sodium Pyrrolidone Carboxylic Acid", "PCA Sodium"]
            ),
            Ingredient(
                name: "Panthenol",
                description: "A provitamin of B5 that deeply moisturizes and helps skin heal.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.humectant, .activeIngredient],
                aliases: ["Pro-Vitamin B5", "Dexpanthenol", "D-Panthenol"]
            )
        ])

        // Active Ingredients (Brightening, Anti-Aging, etc.)
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Alpha Arbutin",
                description: "A tyrosinase inhibitor that helps reduce dark spots and hyperpigmentation.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Arbutin", "4-Hydroxyphenyl Alpha-D-glucopyranoside"]
            ),
            Ingredient(
                name: "Kojic Acid",
                description: "A fungal-derived ingredient that brightens skin and reduces melanin production.",
                safetyRating: .moderate,
                concerns: [.skinIrritant],
                categories: [.activeIngredient],
                aliases: ["Kojic acid"]
            ),
            Ingredient(
                name: "Azelaic Acid",
                description: "A multitasking acid that treats acne, rosacea, and hyperpigmentation.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Nonanedioic Acid", "AzA"]
            ),
            Ingredient(
                name: "Salicylic Acid",
                description: "A beta hydroxy acid that exfoliates pores and treats acne.",
                safetyRating: .safe,
                concerns: [.skinIrritant],
                categories: [.activeIngredient],
                aliases: ["BHA", "2-Hydroxybenzoic Acid"]
            ),
            Ingredient(
                name: "Glycolic Acid",
                description: "An alpha hydroxy acid that exfoliates skin and promotes cell turnover.",
                safetyRating: .safe,
                concerns: [.skinIrritant],
                categories: [.activeIngredient],
                aliases: ["AHA", "Hydroxyacetic Acid"]
            ),
            Ingredient(
                name: "Lactic Acid",
                description: "An alpha hydroxy acid that exfoliates and hydrates. Good for sensitive skin.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient, .humectant],
                aliases: ["2-Hydroxypropanoic Acid"]
            ),
            Ingredient(
                name: "Mandelic Acid",
                description: "A gentle alpha hydroxy acid suitable for beginners and sensitive skin.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Phenylglycolic Acid", "Alpha-hydroxyphenylacetic acid"]
            ),
            Ingredient(
                name: "Tranexamic Acid",
                description: "An amino acid that reduces melanin synthesis and treats hyperpigmentation.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["TXA", "Trans-4-aminomethylcyclohexanecarboxylic acid"]
            ),
            Ingredient(
                name: "Madecassoside",
                description: "A compound from centella asiatica that soothes and repairs skin barrier.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient, .antioxidant],
                aliases: ["Asiaticoside B"]
            ),
            Ingredient(
                name: "Asiaticoside",
                description: "A compound from centella asiatica that promotes collagen synthesis.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: []
            )
        ])

        // Antioxidants
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Resveratrol",
                description: "A potent antioxidant from grapes that protects against free radical damage.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.antioxidant],
                aliases: ["3,4,5-Trihydroxystilbene"]
            ),
            Ingredient(
                name: "Vitamin E",
                description: "A fat-soluble antioxidant that protects cell membranes and moisturizes.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.antioxidant, .emollient],
                aliases: ["Tocopherol", "Alpha-Tocopherol", "Acetate"]
            ),
            Ingredient(
                name: "Ferulic Acid",
                description: "An antioxidant that enhances the effectiveness of vitamins C and E.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.antioxidant],
                aliases: ["4-Hydroxy-3-methoxycinnamic acid"]
            ),
            Ingredient(
                name: "Coenzyme Q10",
                description: "An antioxidant naturally found in skin that declines with age.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.antioxidant],
                aliases: ["CoQ10", "Ubiquinone", "Ubidecarenone"]
            ),
            Ingredient(
                name: "Astaxanthin",
                description: "A powerful carotenoid antioxidant with anti-aging benefits.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.antioxidant],
                aliases: ["Haematococcus pluvialis extract"]
            ),
            Ingredient(
                name: "Bakuchiol",
                description: "A plant-based alternative to retinol with anti-aging benefits.",
                safetyRating: .safe,
                concerns: [],
                categories: [.antioxidant, .activeIngredient],
                aliases: ["Babchi", "Psoralea corylifolia"]
            ),
            Ingredient(
                name: "Sulphoraphane",
                description: "A compound from broccoli sprouts with powerful antioxidant activity.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.antioxidant],
                aliases: ["1-Isothiocyanato-4-methylsulfinylbutane"]
            ),
            Ingredient(
                name: "Idebenone",
                description: "A synthetic analog of CoQ10 with powerful antioxidant properties.",
                safetyRating: .safe,
                concerns: [],
                categories: [.antioxidant],
                aliases: ["Hydroxydecyl ubiquinone"]
            )
        ])

        // Preservatives (Additional)
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Phenoxyethanol",
                description: "A widely used broad-spectrum preservative. Generally considered safe.",
                safetyRating: .safe,
                concerns: [],
                categories: [.preservative],
                aliases: ["Ethylene glycol monophenyl ether", "Arosil"]
            ),
            Ingredient(
                name: "Ethylhexylglycerin",
                description: "A preservative booster that also improves skin feel.",
                safetyRating: .safe,
                concerns: [],
                categories: [.preservative],
                aliases: ["Octoxyglycerin"]
            ),
            Ingredient(
                name: "Caprylyl Glycol",
                description: "A conditioning agent with antimicrobial properties.",
                safetyRating: .safe,
                concerns: [],
                categories: [.preservative, .emollient],
                aliases: ["1,2-Octanediol"]
            ),
            Ingredient(
                name: "Sodium Benzoate",
                description: "A food-grade preservative used in cosmetics. Safe in low concentrations.",
                safetyRating: .safe,
                concerns: [],
                categories: [.preservative],
                aliases: ["Benzoate of soda", "E211"]
            ),
            Ingredient(
                name: "Potassium Sorbate",
                description: "A gentle preservative derived from sorbic acid. Food-grade safe.",
                safetyRating: .safe,
                concerns: [],
                categories: [.preservative],
                aliases: ["E202", "Sorbic acid potassium salt"]
            ),
            Ingredient(
                name: "Benzisothiazolinone",
                description: "A preservative effective against bacteria. May cause sensitization.",
                safetyRating: .moderate,
                concerns: [.allergen],
                categories: [.preservative],
                aliases: ["BIT"]
            ),
            Ingredient(
                name: "Methylisothiazolinone",
                description: "A potent preservative associated with allergic reactions.",
                safetyRating: .concerning,
                concerns: [.allergen, .skinIrritant],
                categories: [.preservative],
                aliases: ["MIT", "MI"]
            )
        ])

        // Botanical Extracts
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Aloe Vera",
                description: "A soothing plant extract with anti-inflammatory and moisturizing properties.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient, .emollient],
                aliases: ["Aloe Barbadensis", "Aloe Vera Leaf Juice"]
            ),
            Ingredient(
                name: "Chamomile Extract",
                description: "A calming botanical with anti-inflammatory and soothing properties.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient, .antioxidant],
                aliases: ["Chamomilla Recutita", "Matricaria", "Bisabolol"]
            ),
            Ingredient(
                name: "Licorice Root Extract",
                description: "A brightening ingredient that soothes skin and reduces redness.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient, .antioxidant],
                aliases: ["Glycyrrhiza Glabra", "Glycyrrhizic Acid", "Glabridin"]
            ),
            Ingredient(
                name: "Turmeric Extract",
                description: "An anti-inflammatory spice extract rich in curcumin.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.antioxidant, .activeIngredient],
                aliases: ["Curcuma Longa", "Curcumin"]
            ),
            Ingredient(
                name: "Willow Bark Extract",
                description: "A natural source of salicin that provides gentle exfoliation.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Salix Alba", "Salicylic acid natural source"]
            ),
            Ingredient(
                name: "Rosehip Oil",
                description: "A nourishing oil rich in vitamin C and essential fatty acids.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient, .antioxidant],
                aliases: ["Rosa Canina", "Rosa Rubiginosa"]
            ),
            Ingredient(
                name: "Hemp Seed Oil",
                description: "A balanced oil rich in omega-3 and omega-6 fatty acids.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient],
                aliases: ["Cannabis Sativa Seed Oil"]
            ),
            Ingredient(
                name: "Sea Buckthorn Oil",
                description: "A nutrient-dense oil with anti-inflammatory and healing properties.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient, .antioxidant],
                aliases: ["Hippophae Rhamnoides"]
            )
        ])

        // Peptides & Proteins
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Argireline",
                description: "A peptide that may help reduce the appearance of expression lines.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Acetyl Hexapeptide-3", "Acetyl Hexapeptide-8"]
            ),
            Ingredient(
                name: "Matrixyl 3000",
                description: "A peptide complex that stimulates collagen production.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Palmitoyl Tripeptide-1", "Palmitoyl Tetrapeptide-7"]
            ),
            Ingredient(
                name: "Copper Peptides",
                description: "Peptides that promote wound healing and skin regeneration.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["GHK-Cu", "Copper tripeptide-1"]
            ),
            Ingredient(
                name: "Collagen",
                description: "A structural protein that provides skin with firmness. Note: Topical collagen cannot directly replace lost collagen.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Hydrolyzed Collagen", "Marine Collagen"]
            ),
            Ingredient(
                name: "Silk Amino Acids",
                description: "Proteins derived from silk that help retain moisture in skin.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.humectant],
                aliases: ["Hydrolyzed Silk", "Sericin"]
            )
        ])

        // Exfoliants
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Polyhydroxy Acid",
                description: "A gentle acid suitable for sensitive skin. Provides exfoliation without irritation.",
                safetyRating: .safe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["PHA", "Gluconolactone", "Lactobionic Acid"]
            ),
            Ingredient(
                name: "Bamboo Exfoliant",
                description: "A natural physical exfoliant made from bamboo powder.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Bamboo powder", "Phyllostachys"]
            ),
            Ingredient(
                name: "Jojoba Beads",
                description: "Biodegradable spherical exfoliants made from jojoba wax.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient],
                aliases: ["Jojoba Ester", "Hydrogenated Jojoba Oil"]
            )
        ])

        // pH Adjusters & Buffers
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Sodium Hydroxide",
                description: "Used to adjust pH of cosmetic formulations. Essential for many products.",
                safetyRating: .safe,
                concerns: [],
                categories: [.solvent],
                aliases: ["Lye", "NaOH", "Caustic soda"]
            ),
            Ingredient(
                name: "Triethanolamine",
                description: "An pH adjuster and emulsifier. Can cause sensitization in some individuals.",
                safetyRating: .moderate,
                concerns: [.allergen],
                categories: [.emulsifier, .solvent],
                aliases: ["TEA", "Trolamine"]
            ),
            Ingredient(
                name: "Aminomethyl Propanol",
                description: "A pH adjuster used in many cosmetic formulations.",
                safetyRating: .safe,
                concerns: [],
                categories: [.solvent],
                aliases: ["AMP", "2-Amino-2-methyl-1-propanol"]
            )
        ])

        // Emulsifiers & Thickeners
        ingredients.append(contentsOf: [
            Ingredient(
                name: "Cetearyl Alcohol",
                description: "A fatty alcohol that acts as an emulsifier and thickener. Non-irritating.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient, .emulsifier],
                aliases: ["Cetostearyl alcohol", "C16-18 alcohol"]
            ),
            Ingredient(
                name: "Glyceryl Stearate",
                description: "An emulsifier that smooths skin and creates a protective barrier.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emollient, .emulsifier],
                aliases: ["Glycerin stearate", "GMS"]
            ),
            Ingredient(
                name: "Xanthan Gum",
                description: "A natural thickener and stabilizer derived from fermentation.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.emulsifier],
                aliases: ["E415"]
            ),
            Ingredient(
                name: "Carbomer",
                description: "A synthetic polymer used as a thickener and gel former.",
                safetyRating: .safe,
                concerns: [],
                categories: [.emulsifier],
                aliases: ["Carbopol", "Polyacrylic acid"]
            ),
            Ingredient(
                name: "Caffeine",
                description: "Can reduce puffiness and dark circles. Also has antioxidant properties.",
                safetyRating: .verySafe,
                concerns: [],
                categories: [.activeIngredient, .antioxidant],
                aliases: ["Methylxanthine", "1,3,7-Trimethylxanthine"]
            )
        ])
    }
}
