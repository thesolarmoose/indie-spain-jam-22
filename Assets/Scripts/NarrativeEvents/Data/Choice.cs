using UnityEngine;
using UnityEngine.Localization;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "Choice", menuName = "Events/Choice", order = 0)]
    public class Choice : ScriptableObject
    {
        [SerializeField] private LocalizedString _description;

        public LocalizedString Description => _description;

        public static Choice Create(LocalizedString description)
        {
            var choice = CreateInstance<Choice>();
            choice._description = description;
            return choice;
        }
    }
}