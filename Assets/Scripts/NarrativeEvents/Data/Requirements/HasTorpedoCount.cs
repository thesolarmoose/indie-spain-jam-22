using System;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using Utils.Serializables;

namespace NarrativeEvents.Data.Requirements
{
    [Serializable]
    public class HasTorpedoCount : ISerializablePredicate, IDrawableRequirement
    {
        [SerializeField] private IntVariable _torpedosCount;
        [SerializeField] private int _requiredCount;
        [SerializeField] private Sprite _torpedoSprite;
        
        public bool IsMet()
        {
            return _torpedosCount.Value >= _requiredCount;
        }

        public Sprite GetSprite()
        {
            return _torpedoSprite;
        }
    }
}